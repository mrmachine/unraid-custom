#!/bin/bash

if [ -d "/tmp/bzroot" ]; then
    mkdir -p /boot/unraid-custom/packages
    cd /boot/unraid-custom/packages

    [ ! -f "python-2.6.4-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/python-2.6.4-i486-1.txz
    [ ! -f "sqlite-3.6.23.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/ap/sqlite-3.6.23.1-i486-1.txz

    [ ! -x "/tmp/bzroot/usr/bin/python" ] && ROOT=/tmp/bzroot installpkg python-2.6.4-i486-1.txz
    [ ! -x "/tmp/bzroot/usr/bin/sqlite3" ] && ROOT=/tmp/bzroot installpkg sqlite-3.6.23.1-i486-1.txz
else
    echo "/tmp/bzroot does not exist."
fi
