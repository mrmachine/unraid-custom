#!/bin/bash

KERNEL=`uname -r | cut -d"-" -f1`

mkdir -p /boot/unraid-custom/packages
mkdir -p /boot/unraid-custom/src
mkdir -p /usr/src/linux-${KERNEL}

cd /boot/unraid-custom/packages

# deps.
[ ! -f "binutils-2.20.51.0.8-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/binutils-2.20.51.0.8-i486-1.txz
[ ! -f "gcc-4.4.4-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/gcc-4.4.4-i486-1.txz
[ ! -f "gcc-g++-4.4.4-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/gcc-g++-4.4.4-i486-1.txz
[ ! -f "glibc-2.11.1-i486-3.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/l/glibc-2.11.1-i486-3.txz
[ ! -f "kernel-headers-2.6.33.4_smp-x86-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/kernel-headers-2.6.33.4_smp-x86-1.txz
[ ! -f "make-3.81-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/make-3.81-i486-1.txz
[ ! -f "ncurses-5.7-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/l/ncurses-5.7-i486-1.txz
[ ! -f "patch-2.5.4-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/a/patch-2.5.4-i486-1.txz
[ ! -f "perl-5.10.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/perl-5.10.1-i486-1.txz

[ ! -d "/usr/doc/binutils-2.20.51.0.8" ] && installpkg binutils-2.20.51.0.8-i486-1.txz
[ ! -x "/usr/bin/gcc" ] && installpkg gcc-4.4.4-i486-1.txz
[ ! -x "/usr/bin/g++" ] && installpkg gcc-g++-4.4.4-i486-1.txz
[ ! -d "/usr/doc/glibc-2.11.1" ] && installpkg glibc-2.11.1-i486-3.txz
[ ! -d "/usr/include/asm-x86" ] && installpkg kernel-headers-2.6.33.4_smp-x86-1.txz
[ ! -x "/usr/bin/make" ] && installpkg make-3.81-i486-1.txz
[ ! -d "/usr/doc/ncurses-5.7" ] && installpkg ncurses-5.7-i486-1.txz
[ ! -x "/usr/bin/patch" ] && installpkg patch-2.5.4-i486-1.txz
[ ! -x "/usr/bin/perl" ] && installpkg perl-5.10.1-i486-1.txz

# source.
cd /boot/unraid-custom/src
[ ! -f "linux-${KERNEL}.tar.gz" ] && wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-${KERNEL}.tar.gz

# build.
tar --strip-components 1 -C /usr/src/linux-${KERNEL} -xvf /boot/unraid-custom/src/linux-${KERNEL}.tar.gz
ln -sf /usr/src/linux-${KERNEL} /usr/src/linux
rsync -avR /usr/src/linux-`uname -r`/./ /usr/src/linux
#sed -i 's/CONFIG_LOCALVERSION="-unRAID"/CONFIG_LOCALVERSION="-custom"/g' /usr/src/linux/.config
cd /usr/src/linux
make oldconfig
make menuconfig
#	Device drivers
#		Multimedia support
#			Video for Linux
#			DVB for Linux
#			Video capture adapters
#				NXP SAA7164 support (HVR-2250)
#			DVB/ATSC adapters
#				support for various usb dvb devices
#					DiBcom DiB0700 USB DVB devices (PlayTV)
make all modules_install install
