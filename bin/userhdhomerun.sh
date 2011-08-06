#!/bin/bash

mkdir -p /boot/unraid-custom/packages
cd /boot/unraid-custom/packages

# deps.
[ ! -f "cmake-2.8.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/cmake-2.8.1-i486-1.txz
[ ! -f "make-3.81-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/make-3.81-i486-1.txz
[ ! -x "/usr/bin/cmake" ] && installpkg cmake-2.8.1-i486-1.txz
[ ! -x "/usr/bin/make" ] && installpkg make-3.81-i486-1.txz

# run.
if [ test -a $(ps auxwww|grep "make run"|grep -v grep|wc -l) -lt 1 ]; then
    cd /boot/unraid-custom/src/dvbhdhomerun/userhdhomerun
    make run 1>/dev/null &
else
    echo UserHDHomeRun is already running.
fi
