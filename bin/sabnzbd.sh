#!/bin/bash

mkdir -p /boot/unraid-custom/packages
mkdir -p /boot/unraid-custom/src

cd /boot/unraid-custom/packages

# deps.
[ ! -f "gettext-0.17-i486-3.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/a/gettext-0.17-i486-3.txz
[ ! -f "infozip-6.0-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/a/infozip-6.0-i486-1.txz
[ ! -f "openssl-0.9.8n-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/n/openssl-0.9.8n-i486-1.txz
[ ! -f "par2cmdline-0.4-i486-1alien.tgz" ] && wget http://connie.slackware.com/~alien/slackbuilds/par2cmdline/pkg/13.0/par2cmdline-0.4-i486-1alien.tgz
[ ! -f "pyopenssl-0.10-i486-2sl.txz" ] && wget http://repository.slacky.eu/slackware-13.1/system/pyopenssl/0.10/pyopenssl-0.10-i486-2sl.txz
[ ! -f "python-2.6.4-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/python-2.6.4-i486-1.txz
[ ! -f "python-cheetah-2.4.2.1-i486-1alien.tgz" ] && wget http://connie.slackware.com/~alien/slackbuilds/python-cheetah/pkg/13.0/python-cheetah-2.4.2.1-i486-1alien.tgz
[ ! -f "python-yenc-0.3-i486-1alien.tgz" ] && wget http://connie.slackware.com/~alien/slackbuilds/python-yenc/pkg/13.0/python-yenc-0.3-i486-1alien.tgz
[ ! -f "sqlite-3.6.23.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/ap/sqlite-3.6.23.1-i486-1.txz
[ ! -f "unrar-3.9.10-i486-2alien.tgz" ] && wget http://connie.slackware.com/~alien/slackbuilds/unrar/pkg/13.1/unrar-3.9.10-i486-2alien.tgz

[ ! -x "/usr/bin/gettext" ] && installpkg gettext-0.17-i486-3.txz
[ ! -x "/usr/bin/unzip" ] && installpkg infozip-6.0-i486-1.txz
[ ! -x "/usr/bin/openssl" ] && installpkg openssl-0.9.8n-i486-1.txz
[ ! -x "/usr/bin/par2" ] && installpkg par2cmdline-0.4-i486-1alien.tgz
[ ! -d "/usr/lib/python2.6/site-packages/OpenSSL" ] && installpkg pyopenssl-0.10-i486-2sl.txz
[ ! -x "/usr/bin/python" ] && installpkg python-2.6.4-i486-1.txz
[ ! -d "/usr/lib/python2.6/site-packages/Cheetah" ] && installpkg python-cheetah-2.4.2.1-i486-1alien.tgz
[ ! -f "/usr/lib/python2.6/site-packages/yenc.py" ] && installpkg python-yenc-0.3-i486-1alien.tgz
[ ! -x "/usr/bin/sqlite3" ] && installpkg sqlite-3.6.23.1-i486-1.txz
[ ! -x "/usr/bin/unrar" ] && installpkg unrar-3.9.10-i486-2alien.tgz

# source.
if [ ! -d "/boot/unraid-custom/SABnzbd" ]; then
	mkdir -p /boot/unraid-custom/SABnzbd
	cd /boot/unraid-custom/src
	[ ! -f "SABnzbd-0.6.6-src.tar.gz" ] && wget http://downloads.sourceforge.net/project/sabnzbdplus/sabnzbdplus/sabnzbd-0.6.6/SABnzbd-0.6.6-src.tar.gz
	tar --strip-components 1 -C /boot/unraid-custom/SABnzbd -xvf SABnzbd-0.6.6-src.tar.gz
fi

# config.
cd /boot/unraid-custom/SABnzbd
[ ! -f "sabnzbd.ini" ] && cp /boot/unraid-custom/etc/sabnzbd.ini sabnzbd.ini

# run.
if [ test -a $(ps auxwww|grep SABnzbd.py|grep -v grep|wc -l) -lt 1 ]; then
	LOG_DIR=$(awk -F ' = ' '$1 == "log_dir" {print $2}' sabnzbd.ini)
	mkdir -p "$LOG_DIR"
	chown -R nobody:users "$LOG_DIR"
	usermod -s /bin/bash nobody > /dev/null 2>&1
	su nobody -c "python SABnzbd.py --daemon > /dev/null 2>&1"
else
	echo SABnzbd is already running.
fi
