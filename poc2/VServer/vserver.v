import despiegk.crystallib.redisclient
import despiegk.crystallib.resp2
import threefoldtech.rmb.server { Message }
import encoding.base64
import json
import os

struct TwinserverConfig {
mut:
	network      string
	mnemonic     string
	store_secret string [json: 'storeSecret']
	rmb_proxy    bool
	keypair_type string [json: 'keypairType']
}

const redis_address = 'localhost:6379'

const supported = [
	'msgbus.vserver.launch_twinserver',
	'msgbus.vserver.machines.list',
	'msgbus.vserver.machines.get',
	'msgbus.vserver.k8s.list',
	'msgbus.vserver.k8s.get',
	'msgbus.vserver.zdbs.list',
	'msgbus.vserver.zdbs.get',
	'msgbus.vserver.gateway.get_fqdn',
	'msgbus.vserver.gateway.get_name',
	'msgbus.vserver.qsfs_zdbs.list',
	'msgbus.vserver.qsfs_zdbs.get',
	'msgbus.vserver.contracts.get',
	'msgbus.vserver.contracts.get_contract_id_by_node_id_and_hash',
	'msgbus.vserver.contracts.get_name_contract',
	'msgbus.vserver.contracts.listMyContracts',
	'msgbus.vserver.contracts.listContractsByTwinId',
	'msgbus.vserver.contracts.listContractsByAddress',
	'msgbus.vserver.contracts.getConsumption',
	'msgbus.vserver.twins.get',
	'msgbus.vserver.twins.get_my_twin_id',
	'msgbus.vserver.twins.get_twin_id_by_account_id',
	'msgbus.vserver.twins.list',
	'msgbus.vserver.kvstore.set',
	'msgbus.vserver.kvstore.get',
	'msgbus.vserver.kvstore.list',
	'msgbus.vserver.balance.get',
	'msgbus.vserver.balance.getMyBalance',
	'msgbus.vserver.capacity.getFarms',
	'msgbus.vserver.capacity.getNodes',
	'msgbus.vserver.capacity.getAllFarms',
	'msgbus.vserver.capacity.getAllNodes',
	'msgbus.vserver.capacity.filterNodes',
	'msgbus.vserver.capacity.checkFarmHasFreeicIps',
	'msgbus.vserver.capacity.getNodesByFarmId',
	'msgbus.vserver.capacity.getNodeFreeResources',
	'msgbus.vserver.capacity.getFarmIdFromFarmName',
	'msgbus.vserver.stellar.get',
	'msgbus.vserver.stellar.exist',
	'msgbus.vserver.stellar.list',
	'msgbus.vserver.stellar.balance_by_name',
	'msgbus.vserver.stellar.balance_by_address',
]

const not_supported = [
	'msgbus.vserver.machines.deploy',
	'msgbus.vserver.machines.delete',
	'msgbus.vserver.machines.update',
	'msgbus.vserver.machines.add_machine',
	'msgbus.vserver.machines.delete_machine',
	'msgbus.vserver.k8s.deploy',
	'msgbus.vserver.k8s.delete',
	'msgbus.vserver.k8s.update',
	'msgbus.vserver.k8s.add_worker',
	'msgbus.vserver.k8s.delete_worker',
	'msgbus.vserver.zdbs.deploy',
	'msgbus.vserver.zdbs.delete',
	'msgbus.vserver.zdbs.update',
	'msgbus.vserver.zdbs.add_zdb',
	'msgbus.vserver.zdbs.delete_zdb',
	'msgbus.vserver.gateway.deploy_fqdn',
	'msgbus.vserver.gateway.deploy_name',
	'msgbus.vserver.gateway.delete_fqdn',
	'msgbus.vserver.gateway.delete_name',
	'msgbus.vserver.qsfs_zdbs.deploy',
	'msgbus.vserver.qsfs_zdbs.delete',
	'msgbus.vserver.zos.deploy',
	'msgbus.vserver.contracts.create_node',
	'msgbus.vserver.contracts.create_name',
	'msgbus.vserver.contracts.update_node',
	'msgbus.vserver.contracts.cancel',
	'msgbus.vserver.contracts.cancelMyContracts',
	'msgbus.vserver.twins.create',
	'msgbus.vserver.twins.delete',
	'msgbus.vserver.kvstore.remove',
	'msgbus.vserver.kvstore.removeAll',
	'msgbus.vserver.balance.transfer',
	'msgbus.vserver.stellar.import',
	'msgbus.vserver.stellar.update',
	'msgbus.vserver.stellar.transfer',
	'msgbus.vserver.stellar.delete',
]

// Check if twinserver already running
fn is_twinserver_running() (bool, []string) {
	count_cmd := os.execute('pgrep -f -c twinserver')
	count := count_cmd.output.int()
	if count_cmd.exit_code == 0 && count > 1 {
		pids_str := os.execute('pgrep -f twinserver')
		pids := pids_str.output.split('\n')
		println('[+] Local twinserver already running on PIDS : $pids')
		return true, pids
	} else {
		println('[-] Local twinserver not running')
		return false, []string{}
	}
}

// Launch twinserver with configuration (ex. from weblet)
fn launch_twinserver(config string) ? {
	decoded_config := base64.decode_str(config)
	println(config)
	println(decoded_config)
	mut twin_config := json.decode(TwinserverConfig, decoded_config) or {
		panic('Fail to decode TwinserverConfig with error: $err')
	}
	twin_config.keypair_type = 'sr25519'
	twin_config_dir_path := '/tmp/vserver'
	twin_config_file_name := 'twinserver_config.json'
	os.mkdir_all(twin_config_dir_path) ?
	os.write_file('$twin_config_dir_path/$twin_config_file_name', json.encode_pretty(twin_config)) ?
	os.execute('npx twinserver --config $twin_config_dir_path/$twin_config_file_name')
}

// Edit command and redirect to twinserver to handle it
fn redirect_to_twinserver(mut r redisclient.Redis, mut message Message) ? {
	message.command = message.command.replace('vserver', 'twinserver')
	println('[+] Redirect Msg to local twinserver')
	mod_command := 'msgbus.' + message.command
	mod_msg := json.encode_pretty(message)
	println('[+] Key: $mod_command')
	println('[+] Value: $mod_msg')
	r.lpush(mod_command, mod_msg) ?
}

// Return error msg
fn return_error(mut r redisclient.Redis, mut message Message, msg string) ? {
	message.err = msg
	source := message.twin_src
	message.twin_src = message.twin_dst[0]
	message.twin_dst = [source]
	err_msg := json.encode_pretty(message)
	println('[-] Reply for [$message.retqueue] with error:  $msg')
	r.lpush(message.retqueue, err_msg) ?
}

// Return response msg
fn return_response(mut r redisclient.Redis, mut message Message, msg string) ? {
	message.data = base64.encode_str(msg)
	source := message.twin_src
	message.twin_src = message.twin_dst[0]
	message.twin_dst = [source]
	response := json.encode_pretty(message)
	println('[+] Reply for [$message.retqueue]')
	println('[+] $response')
	r.lpush(message.retqueue, response) ?
}

fn main() {
	// Connect as redis client
	mut redis := redisclient.connect(redis_address) or {
		panic("Can't connect to redis on $redis_address")
	}
	println('[+] VServer running and listening on $redis_address ...')
	println('[+] VServer waiting requests ...')

	// Init variables
	mut known_commands := []string{}
	known_commands << supported
	known_commands << not_supported

	// Loop forever to catch any known command
	for {
		// Using BLPOP command to catch commands.
		msg := redis.blpop(known_commands, '0') or { panic("Can't blpop with error: $err") }
		// Decode Message and get the command.
		msg_rv := resp2.get_redis_value(msg[1])
		mut msg_value := json.decode(Message, msg_rv) or {
			panic('Fail to decode Message with error: $err')
		}
		mod_command := 'msgbus.' + msg_value.command

		/*
		* We have 3 case for the command:
		 * 1- Launch twinserver --> Check if running, close old one and launch a new one.
		 * 2- Supported --> Redirect to twinserver.
		 * 3- Not Supported --> Send error msg that command not supported.
		*/
		if mod_command == 'msgbus.vserver.launch_twinserver' {
			mut is_running, mut pids := is_twinserver_running()
			if is_running {
				// Kill all related process to olf twinserver to start a new one.
				println('[-] Kill old twinserver with pids: $pids ')
				os.execute('kill -9 ${pids.join(' ')}')
			}
			// Start a new twinserver
			go launch_twinserver(msg_value.data) // or {panic ("Fail to launch twinserver with error: $err")}
			is_running, _ = is_twinserver_running()

			// Check again that server run successfully and reply.
			if is_running {
				println('[+] Twinserver running successfully')
				return_response(mut redis, mut msg_value, '{"success": true}') or {
					panic("Can't return response message with error: $err")
				}
			} else {
				println('[-] Fail to launch twinserver')
				return_error(mut redis, mut msg_value, 'Failed to launch twinserver') or {
					panic("Can't return error message with error: $err")
				}
			}
			println('[+] VServer waiting requests ...')
		} else if mod_command in supported {
			println('[+] Redirect $msg_value.command to twinserver')
			redirect_to_twinserver(mut redis, mut msg_value) or {
				panic("Can't redirect to twinserver with error: $err")
			}
			println('[+] VServer waiting requests ...')
		} else {
			println('[+] Return Error with retqueue $msg_value.retqueue')
			return_error(mut redis, mut msg_value, 'Not supported command') or {
				panic("Can't return error message with error: $err")
			}
			println('[+] $msg_value')
			println('[+] VServer waiting requests ...')
		}
	}
}
