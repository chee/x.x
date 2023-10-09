#!/bin/bash
function check_path() {
	     /usr/bin/env which $1 &> /dev/null
}

if check_path /opt/homebrew/bin/brew; then
		eval $(/opt/homebrew/bin/brew shellenv)
fi
pkg_manager=""
check_path brew && pkg_manager=homebrew
check_path port && pkg_manager=macports
if [ -z "$pkg_manager" ]; then
	echo "Please install homebrew or macports"
	echo "https://brew.sh/"
	echo "https://ports.macports.org/port/MacPorts/"
	exit 47
fi
prefix=""
case $pkg_manager in
   homebrew)
		brew install nginx dnsmasq moreutils
		prefix="/opt/homebrew"
	;;
	macports)
		sudo port install nginx dnsmasq moreutils
		prefix="/opt/local"
	;;
esac

echo address=/.x.x/127.0.0.1 | sudo sponge -a "$prefix/etc/dnsmasq.conf"
mkdir -p $HOME/x.x/
echo "include $HOME/x.x/nginx.conf;" | sudo sponge "$prefix/etc/nginx/nginx.conf"
cp nginx.conf $HOME/x.x/nginx.conf
case $pkg_manager in
   homebrew)
		# dnsmasq must be run as root to start at system startup
		sudo brew services start dnsmasq
		# nginx must NOT be run as root to start at system startup
		brew services start nginx
	;;
	macports)
		sudo port load dnsmasq
		sudo port load nginx
	;;
esac
./gencert.bash
echo "make sure to add 127.0.0.1 to your dns servers"
echo "networksetup -setdnsservers Wi-Fi 127.0.0.1 1.1.1.1"
