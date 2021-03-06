#!/bin/bash

mkdir -p /boot/unraid-custom/packages
cd /boot/unraid-custom/packages

# deps.
[ ! -f "python-2.6.4-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/python-2.6.4-i486-1.txz
[ ! -f "sqlite-3.6.23.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/ap/sqlite-3.6.23.1-i486-1.txz
[ ! -x "/usr/bin/python" ] && installpkg python-2.6.4-i486-1.txz
[ ! -x "/usr/bin/sqlite3" ] && installpkg sqlite-3.6.23.1-i486-1.txz

# source.
if [ ! -d "/boot/unraid-custom/CouchPotato" ]; then
	[ ! -f "curl-7.20.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/n/curl-7.20.1-i486-1.txz
	[ ! -f "git-1.7.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/git-1.7.1-i486-1.txz
	[ ! -x "/usr/bin/curl" ] && installpkg curl-7.20.1-i486-1.txz
	[ ! -x "/usr/bin/git" ] && installpkg git-1.7.1-i486-1.txz
	git clone https://github.com/RuudBurger/CouchPotato.git /boot/unraid-custom/CouchPotato
fi

# config.
cd /boot/unraid-custom/CouchPotato
[ ! -f "config.ini" ] && cp /boot/unraid-custom/etc/couchpotato.ini config.ini

# run.
if [ test -a $(ps auxwww|grep CouchPotato.py|grep -v grep|wc -l) -lt 1 ]; then
	LOG_DIR="/var/log/unraid-custom/couchpotato"
	mkdir -p "$LOG_DIR"
	chown -R nobody:users "$LOG_DIR"
	usermod -s /bin/bash nobody > /dev/null 2>&1
	su nobody -c "python CouchPotato.py -d > /dev/null 2>&1"
else
	echo Couch Potato is already running.
fi
