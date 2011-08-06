#!/bin/bash

if [ -d "/tmp/bzroot" ]; then
    mkdir -p /boot/unraid-custom/packages
    cd /boot/unraid-custom/packages

    [ ! -f "python-2.6.4-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/python-2.6.4-i486-1.txz
    [ ! -f "python-cheetah-2.4.2.1-i486-1alien.tgz" ] && wget http://connie.slackware.com/~alien/slackbuilds/python-cheetah/pkg/13.0/python-cheetah-2.4.2.1-i486-1alien.tgz
    [ ! -f "sqlite-3.6.23.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/ap/sqlite-3.6.23.1-i486-1.txz

    [ ! -x "/tmp/bzroot/usr/bin/python" ] && ROOT=/tmp/bzroot installpkg python-2.6.4-i486-1.txz
    [ ! -d "/tmp/bzroot/usr/lib/python2.6/site-packages/Cheetah" ] && ROOT=/tmp/bzroot installpkg python-cheetah-2.4.2.1-i486-1alien.tgz
    [ ! -x "/tmp/bzroot/usr/bin/sqlite3" ] && ROOT=/tmp/bzroot installpkg sqlite-3.6.23.1-i486-1.txz
else
    echo "/tmp/bzroot does not exist."
fi
