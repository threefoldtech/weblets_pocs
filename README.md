# Weblets POC

In this repo there are 5 pocs as following:

## POC1: PKID Weblet

- Use KVS for storing metadata with TFConnect, [see](poc1/README.md)

## POC2: VServer Weblet

- Use VServer to terminate RMB over http, [see](poc2/README.md)

## POC3: NodeJS as Backend Stellar Examples

- Use NodeJS as backend to import and get balance for stellar wallets, [see](poc3/README.md)

## POC4: Weblet Template

- example to show how easy to create your weblet, [see](poc4/README.md)

## POC5: Tendermint + PostgresSql

_in progress_

## Development Image

- entrypoint: /init.sh
- Dockerfile: https://github.com/threefoldtech/tf-images/blob/development/tfgrid3/ubuntu_devenv/Dockerfile
- flist: https://hub.grid.tf/essam.3bot/mohammedessam-ubuntu_devenv-20.04.flist _`Will be changed with official one later`_.

### Environment Variables

- SSH_KEY
- TWIN*ID \_optional*
- CODESERVER*PASSWORD \_optional* `default: tfdev001`

> These environment variables should be updated in the [terraform file](./terraform/main.tf) before the deployment

### Used Ports

- 8881 : poc1 weblet
- 8882 : poc2 weblet
- 8884 : poc4 weblet
- 8886 : code-server _also code-server works on 8080 but on localhost_
