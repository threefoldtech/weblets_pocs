import despiegk.crystallib.twinclient

fn main() {
	redis_server := 'localhost:6379'
	twin_id := 0

	if twin_id == 0 {
		panic("Please add your twin id, and run again")
	}
	mut client := twinclient.init(redis_server, twin_id) or {
		panic('Fail in init client with error: $err')
	}

	wallet_name := "mainwallet"
	wallet_secret := "ADD_YOUR_SECRET"

	if wallet_secret == "ADD_YOUR_SECRET" {
		panic("Please add your wallet secret, and run again")
	}
	wallet := client.import_wallet(name: wallet_name, secret: wallet_secret) or { panic(err) }
	println(wallet)
	wallet_balance := client.balance_by_name(wallet_name) or { panic(err) }
	println(wallet_balance)
}