# POC2

- Implement a web component that send messages using RMB over https.
- Implement v server as a backend to handle the messages, check commands and redirect allowed commands to twinserver.
- Add helper scripts to run msgbus daemon and twinserver.
- All these can run inside our [Development Image](https://hub.docker.com/repository/docker/mohammedessam/ubuntu_devenv).

> Assuming current directory is `poc2`.

## VWeblet

- Run VWeblet to be hosted on ipv6 interface on port 8882

```sh
cd VWeblet
yarn vtwin
```

## Vserver

- Run VServer

```sh
cd VServer
./build_vserver.sh
vserver
```

> vserver running by default on our [Development Image](https://hub.docker.com/repository/docker/mohammedessam/ubuntu_devenv).

## Scripts

There are 2 helper scripts to run msgbus daemon and twinserver

### Msgbusd

```sh
cd scripts
./run_msgbusd.sh -t <YOUR TWIN_ID> # run on DEVNET by default
#or
./run_msgbusd.sh -t <YOUR TWIN_ID> -n <NETWORK_ENV>
```

> msgbus daemon running by default if you pass `TWIN_ID` as environment variable to our [Development Image](https://hub.docker.com/repository/docker/mohammedessam/ubuntu_devenv)

### Twinserver

```sh
cd scripts
./run_twinserver -n <NETWORK_ENV> -m <MNEMONIC> -s <STORE_SECRET>
```

> NETWORK_ENV: [dev, test, main]
