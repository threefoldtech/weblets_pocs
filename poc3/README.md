# POC3

- Use NodeJS server as a backend.
- Stellar example in TS and V.

> This part taken from Twin server documentation with some modifications, for [full documentation](https://github.com/threefoldtech/grid3_client_ts/blob/development/docs/server.md)

## Twin server

Twin server is an RMB server that exposes the functionality of the grid3 client over RMB.

### Prerequisites

- Redis server
- RMB server, run it with helper script, [see](../poc2/README.md#Msgbusd)

### Configuration

Create a `config.json` file include the following configurations.

```json
{
  "network": "<network environment dev or test>",
  "mnemonic": "<your account mnemonics>",
  "rmb_proxy": false, // in case http rmb proxy needs to be used
  "storeSecret": "secret", // secret used for encrypting/decrypting the values in tfkvStore
  "keypairType": "sr25519" // keypair type for the account created on substrate
}
```

### Installation and Running

- Install grid3_client

> grid3_client installed globally in our [Development Image](https://hub.docker.com/repository/docker/mohammedessam/ubuntu_devenv), you can **skip** this step.

```sh
npm install grid3_client
```

- Run twinserver

```sh
npx twinserver --config config.json
```

or using helper script [see](../poc2/README.md###Twinserver).

## Example

> Assuming current directory is `poc3`.

### TS

- Install needed packages

```sh
npm install
```

- Run stellar example

```sh
ts-node stellar_example.ts
```

### V

```sh
v run stellar_example.v
```

> Don't forget to edit the example with your data, it will not **WORK**.
