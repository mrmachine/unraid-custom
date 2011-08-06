#!/bin/bash

cd /tmp

if [ ! -x "/usr/bin/curl" ]; then
	wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/n/curl-7.20.1-i486-1.txz
	installpkg curl-7.20.1-i486-1.txz
fi

if [ ! -x "/usr/bin/git" ]; then
	wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/git-1.7.1-i486-1.txz
	installpkg git-1.7.1-i486-1.txz
fi

if [ ! -d "/boot/unraid-custom" ]; then
	git clone https://github.com/mrmachine/unraid-custom.git /boot/unraid-custom
else
	if [ ! -d "/boot/unraid-custom/.git" ]; then
		echo /boot/unraid-custom already exists, and is not a git repository.
	else
		cd /boot/unraid-custom
		git pull
	fi
fi
