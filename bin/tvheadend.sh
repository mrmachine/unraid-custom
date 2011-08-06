#!/bin/bash

mkdir -p /boot/unraid-custom/etc/tvheadend
mkdir -p /boot/unraid-custom/packages

if [ ! -d "/boot/unraid-custom/src/tvheadend/build.Linux" ]; then
    cd /boot/unraid-custom/packages

    # deps.
    [ ! -f "binutils-2.20.51.0.8-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/binutils-2.20.51.0.8-i486-1.txz
    [ ! -f "curl-7.20.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/n/curl-7.20.1-i486-1.txz
    [ ! -f "gcc-4.4.4-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/gcc-4.4.4-i486-1.txz
    [ ! -f "git-1.7.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/git-1.7.1-i486-1.txz
    [ ! -f "glibc-2.11.1-i486-3.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/l/glibc-2.11.1-i486-3.txz
    [ ! -f "kernel-headers-2.6.33.4_smp-x86-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/kernel-headers-2.6.33.4_smp-x86-1.txz
    [ ! -f "openssl-0.9.8n-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/n/openssl-0.9.8n-i486-1.txz
    [ ! -f "pkg-config-0.23-i486-2.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/pkg-config-0.23-i486-2.txz

    [ ! -d "/usr/doc/binutils-2.20.51.0.8" ] && installpkg binutils-2.20.51.0.8-i486-1.txz
    [ ! -x "/usr/bin/curl" ] && installpkg curl-7.20.1-i486-1.txz
    [ ! -x "/usr/bin/gcc" ] && installpkg gcc-4.4.4-i486-1.txz
    [ ! -x "/usr/bin/git" ] && installpkg git-1.7.1-i486-1.txz
    [ ! -d "/usr/doc/glibc-2.11.1" ] && installpkg glibc-2.11.1-i486-3.txz
    [ ! -d "/usr/include/asm-x86" ] && installpkg kernel-headers-2.6.33.4_smp-x86-1.txz
    [ ! -x "/usr/bin/openssl" ] && installpkg openssl-0.9.8n-i486-1.txz
    [ ! -x "/usr/bin/pkg-config" ] && installpkg pkg-config-0.23-i486-2.txz

    # source.
    if [ ! -d "/boot/unraid-custom/src/tvheadend" ]; then
        git clone https://github.com/andoma/tvheadend.git /boot/unraid-custom/src/tvheadend
    else
        git update /boot/unraid-custom/src/tvheadend
    fi

    # build.
    cd /boot/unraid-custom/src/tvheadend
    ./configure --disable-avahi --release
    make clean all
fi

# run.
if [ test -a $(ps auxwww|grep Linux/tvheadend|grep -v grep|wc -l) -lt 1 ]; then
	usermod -G video -a nobody > /dev/null 2>&1
	/boot/unraid-custom/src/tvheadend/build.Linux/tvheadend -c /boot/unraid-custom/etc/tvheadend -f -u nobody -C
else
	echo Tvheadend is already running.
fi
