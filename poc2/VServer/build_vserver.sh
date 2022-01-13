#!/bin/sh
set -e

echo "Build vsever"
v -cc gcc -cflags -static vserver.v && strip vserver
sudo mv vserver /usr/local/bin
echo "Build Done!"
echo "Just write vserver in the terminal and will work!"