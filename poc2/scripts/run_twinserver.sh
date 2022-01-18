#!/bin/bash
mkdir -p /tmp/vserver

while getopts n:m:s: flag
do
    case "${flag}" in
        n) network=${OPTARG};;
        m) mnemonic=${OPTARG};;
        s) storeSecret=${OPTARG};;
    esac
done

if [[ -z $network || -z $mnemonic || -z $storeSecret ]];
then
    echo "Can't run twinserver, missing arguments
- Arguments:
    -n Choose network environment [dev or test or main]
    -m Account mnemonics
    -s KVStore secret"
else
    echo "{
        \"network\": \"${network}\",
        \"mnemonic\": \"${mnemonic}\",
        \"rmb_proxy\": false,
        \"storeSecret\": \"${storeSecret}\",
        \"keypairType\": \"sr25519\"
    }" > /tmp/vserver/twinserver_config.json
    twinserver --config /tmp/vserver/twinserver_config.json &>> /var/log/twinserver &
fi
