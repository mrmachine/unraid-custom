#!/bin/bash

mkdir -p /boot/unraid-custom/packages
cd /boot/unraid-custom/packages
[ ! -e "openssh-5.5p1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/n/openssh-5.5p1-i486-1.txz

if [ ! -x "/usr/sbin/sshd" ]; then
    # restore from unraid-custom.
    if [ -d "/boot/unraid-custom/etc/ssh" ]; then
    	mkdir -p /etc/ssh
    	cp --preserve=timestamps /boot/unraid-custom/etc/ssh/* /etc/ssh
    	chmod 600 /etc/ssh/ssh*key*
    fi

    # install.
    installpkg openssh-5.5p1-i486-1.txz
fi

# config.
[ -d "/boot/unraid-custom/.ssh" ] && cp -rf /boot/unraid-custom/.ssh /root
[ -f "/root/.ssh/authorized_keys" ] && chmod 600 /tmp/bzroot/root/.ssh/authorized_keys

# start sshd.
if [ test -a $(ps auxwww|grep sshd|grep -v grep|wc -l) -lt 1 ]; then
    /etc/rc.d/rc.sshd start
else
	echo OpenSSH is already running.
fi

# save to unraid-custom.
if [ ! -d "/boot/unraid-custom/etc/ssh" ]; then
	mkdir -p /boot/unraid-custom/etc/ssh
	cp --preserve=timestamps /etc/ssh/* /boot/unraid-custom/etc/ssh
fi
