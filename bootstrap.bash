#!/bin/bash
sudo port install nginx dnsmasq moreutils
echo address=/.x.x/127.0.0.1 | sudo sponge -a /opt/local/etc/dnsmasq.conf
mkdir -p $HOME/x.x/
echo "include $HOME/x.x/nginx.conf;" | sudo sponge /opt/local/etc/nginx/nginx.conf
cp nginx.conf $HOME/x.x/nginx.conf
sudo port load dnsmasq
sudo port load nginx
./gencert.bash
echo "make sure to add 127.0.0.1 to your dns servers"
