#!/bin/bash

while getopts t:n: flag
do
    case "${flag}" in
        t) twin=${OPTARG};;
        n) network=${OPTARG};;
    esac
done

if [[ -z $twin ]];
then
    echo "Can't run msgbusd, missing argumnets.
- Arguments:
    -t twin id
    -n Choose network environment [dev , test,  main] (optional) (default: dev)"
else
    if [[ -z $network ]]; then
        echo "Run msgbusd with twin $twin and on devnet"
        msgbusd --twin $twin &>> /var/log/msgbusd &
    else
        case "${network}" in
            dev) sub="wss://tfchain.dev.grid.tf/ws";;
            test) sub="wss://tfchain.test.grid.tf/ws";;
            main) sub="wss://tfchain.grid.tf/ws";;
        esac
        echo "Run msgbusd with twin $twin and on ${network}net"
        msgbusd --twin $twin --substrate $sub &>> /var/log/msgbusd &
    fi
fi
