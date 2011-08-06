#!/bin/bash

if [ -d "/tmp/bzroot" ]; then
    KERNEL=`uname -r`

    mkdir -p /boot/unraid-custom/packages
    cd /boot/unraid-custom/packages

    # deps.
    [ ! -f "cpio-2.9-i486-2.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/a/cpio-2.9-i486-2.txz
    [ ! -x "/bin/cpio" ] && installpkg cpio-2.9-i486-2.txz

    # root .profile.
    [ ! -f "/boot/unraid-custom/.profile" ] && touch /boot/unraid-custom/.profile
    ln -sf /boot/unraid-custom/.profile /tmp/bzroot/root/.profile

    # kernel.
    cp -f /usr/src/linux/.config /tmp/bzroot/usr/src/linux-${KERNEL}
    cp -f /usr/src/linux/System.map /tmp/bzroot/usr/src/linux-${KERNEL}

    # modules.
    rsync -av --delete /lib/modules /tmp/bzroot/lib

    # cleanup.
    [ -d "/tmp/bzroot/usr/include" ] && find /tmp/bzroot/usr/include -type f -exec rm {} \;
    [ -d "/tmp/bzroot/usr/lib" ] && find /tmp/bzroot/usr/lib -name '*.a' -type f -exec rm {} \;
    [ -d "/tmp/bzroot/usr/man" ] && find /tmp/bzroot/usr/man -type f -exec rm {} \;

    # bzroot.
    cd /tmp/bzroot
    find . | cpio -o -H newc | gzip > /boot/bzroot_custom

    # bzimage.
    [ -f "/boot/vmlinuz" ] && mv /boot/vmlinuz /boot/bzimage_custom

    sync

    echo "#"
    echo "# Remember to update /boot/syslinux.conf"
    echo "#"
else
    echo "/tmp/bzroot does not exist."
fi
