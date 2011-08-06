#!/bin/bash

if [ -d "/tmp/bzroot" ]; then
    mkdir -p /boot/unraid-custom/packages
    cd /boot/unraid-custom/packages

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

    [ ! -x "/tmp/bzroot/usr/bin/gettext" ] && ROOT=/tmp/bzroot installpkg gettext-0.17-i486-3.txz
    [ ! -x "/tmp/bzroot/usr/bin/unzip" ] && ROOT=/tmp/bzroot installpkg infozip-6.0-i486-1.txz
    [ ! -x "/tmp/bzroot/usr/bin/openssl" ] && ROOT=/tmp/bzroot installpkg openssl-0.9.8n-i486-1.txz
    [ ! -x "/tmp/bzroot/usr/bin/par2" ] && ROOT=/tmp/bzroot installpkg par2cmdline-0.4-i486-1alien.tgz
    [ ! -d "/tmp/bzroot/usr/lib/python2.6/site-packages/OpenSSL" ] && ROOT=/tmp/bzroot installpkg pyopenssl-0.10-i486-2sl.txz
    [ ! -x "/tmp/bzroot/usr/bin/python" ] && ROOT=/tmp/bzroot installpkg python-2.6.4-i486-1.txz
    [ ! -d "/tmp/bzroot/usr/lib/python2.6/site-packages/Cheetah" ] && ROOT=/tmp/bzroot installpkg python-cheetah-2.4.2.1-i486-1alien.tgz
    [ ! -f "/tmp/bzroot/usr/lib/python2.6/site-packages/yenc.py" ] && ROOT=/tmp/bzroot installpkg python-yenc-0.3-i486-1alien.tgz
    [ ! -x "/tmp/bzroot/usr/bin/sqlite3" ] && ROOT=/tmp/bzroot installpkg sqlite-3.6.23.1-i486-1.txz
    [ ! -x "/tmp/bzroot/usr/bin/unrar" ] && ROOT=/tmp/bzroot installpkg unrar-3.9.10-i486-2alien.tgz
else
    echo "/tmp/bzroot does not exist."
fi
