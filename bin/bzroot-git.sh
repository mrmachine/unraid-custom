#!/bin/bash

if [ -d "/tmp/bzroot" ]; then
    mkdir -p /boot/unraid-custom/packages
    cd /boot/unraid-custom/packages

    [ ! -f "curl-7.20.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/n/curl-7.20.1-i486-1.txz
    [ ! -f "git-1.7.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/git-1.7.1-i486-1.txz

    [ ! -x "/tmp/bzroot/usr/bin/curl" ] && ROOT=/tmp/bzroot installpkg curl-7.20.1-i486-1.txz
    [ ! -x "/tmp/bzroot/usr/bin/git" ] && ROOT=/tmp/bzroot installpkg git-1.7.1-i486-1.txz
else
    echo "/tmp/bzroot does not exist."
fi
