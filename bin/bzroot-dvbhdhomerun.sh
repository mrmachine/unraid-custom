#!/bin/bash
    
if [ -d "/tmp/bzroot" ]; then
    KERNEL=`uname -r | cut -d"-" -f1`
    KERNEL_UNRAID="${KERNEL}-unRAID"

    mkdir -p /boot/unraid-custom/firmware
    mkdir -p /boot/unraid-custom/packages
    mkdir -p /boot/unraid-custom/src
    mkdir -p /tmp/bzroot/etc/rc.d

    # firmware.
    cd /boot/unraid-custom/firmware
    [ ! -f "dvb-usb-dib0700-1.20.fw" ] && wget http://www.linuxtv.org/downloads/firmware/dvb-usb-dib0700-1.20.fw
    [ ! -f "NXP7164-2010-03-10.1.fw" ] && wget http://www.steventoth.net/linux/hvr22xx/firmwares/4019072/NXP7164-2010-03-10.1.fw
    cp -f dvb-usb-dib0700-1.20.fw /tmp/bzroot/lib/firmware # DiB0700 (PlayTV)
    cp -f NXP7164-2010-03-10.1.fw /tmp/bzroot/lib/firmware # SAA7164 (HVR-2250)

    # deps.
    cd /boot/unraid-custom/packages
    [ ! -f "cmake-2.8.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/cmake-2.8.1-i486-1.txz
    [ ! -f "cvs-1.11.23-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/cvs-1.11.23-i486-1.txz
    [ ! -x "/usr/bin/cmake" ] && installpkg cmake-2.8.1-i486-1.txz
    [ ! -x "/usr/bin/cvs" ] && installpkg cvs-1.11.23-i486-1.txz

    # source.
    cd /boot/unraid-custom/src
    if [ ! -d "dvbhdhomerun" ]; then
        cvs -z3 -d:pserver:anonymous@dvbhdhomerun.cvs.sourceforge.net:/cvsroot/dvbhdhomerun co -P dvbhdhomerun
    else
        cvs -z3 -d:pserver:anonymous@dvbhdhomerun.cvs.sourceforge.net:/cvsroot/dvbhdhomerun up -P dvbhdhomerun
    fi
    [ ! -f "libhdhomerun_20110801.tgz" ] && wget http://download.silicondust.com/hdhomerun/libhdhomerun_20110801.tgz

    # kernel module.
    cd /boot/unraid-custom/src/dvbhdhomerun/kernel
    cp /boot/System.map /boot/System.map-${KERNEL_UNRAID}
    make clean install
    if [ -f /tmp/bzroot/etc/rc.d/rc.modules ]; then
        echo "/sbin/modprobe dvb_hdhomerun" >> /tmp/bzroot/etc/rc.d/rc.modules
    else
        echo "/sbin/modprobe dvb_hdhomerun" > /tmp/bzroot/etc/rc.d/rc.modules
    fi

    # libhdhomerun.
    tar -C /usr/lib -zxvf /boot/unraid-custom/src/libhdhomerun_20110801.tgz
    cd /usr/lib/libhdhomerun
    make clean all
    rsync -av --delete . /tmp/bzroot/usr/lib/libhdhomerun

    # userhdhomerun.
    cd /boot/unraid-custom/src/dvbhdhomerun/userhdhomerun
    make clean all

    # config.
    cp -f /boot/unraid-custom/etc/dvbhdhomerun /tmp/bzroot/etc/dvbhdhomerun

    # runtime deps.
    cd /boot/unraid-custom/packages
    [ ! -x "/tmp/bzroot/usr/bin/cmake" ] && ROOT=/tmp/bzroot installpkg cmake-2.8.1-i486-1.txz
    [ ! -x "/tmp/bzroot/usr/bin/make" ] && ROOT=/tmp/bzroot installpkg make-3.81-i486-1.txz
else
    echo "/tmp/bzroot does not exist."
fi
