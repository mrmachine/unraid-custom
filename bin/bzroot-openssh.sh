#!/bin/bash

if [ -d "/tmp/bzroot" ]; then
    mkdir -p /boot/unraid-custom/packages
    cd /boot/unraid-custom/packages

    # deps.
    [ ! -f "openssh-5.5p1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/n/openssh-5.5p1-i486-1.txz
    [ ! -x "/usr/sbin/sshd" ] && installpkg openssh-5.5p1-i486-1.txz

    # keys.
    /etc/rc.d/rc.sshd start
    rsync -av /etc/ssh /tmp/bzroot/etc

    # bzroot.
    [ ! -x "/tmp/bzroot/usr/sbin/sshd" ] && ROOT=/tmp/bzroot installpkg openssh-5.5p1-i486-1.txz
else
    echo "/tmp/bzroot does not exist."
fi
