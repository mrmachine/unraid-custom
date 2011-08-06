#!/bin/bash

if [ -d "/tmp/bzroot" ]; then
    mkdir -p /boot/unraid-custom/packages
    cd /boot/unraid-custom/packages
    [ ! -f "screen-4.0.3-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/ap/screen-4.0.3-i486-1.txz
    [ ! -x "/tmp/bzroot/usr/bin/screen" ] && ROOT=/tmp/bzroot installpkg screen-4.0.3-i486-1.txz
else
    echo "/tmp/bzroot does not exist."
fi
