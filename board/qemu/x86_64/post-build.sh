#!/bin/sh

set -u
set -e

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # QEMU graphical window' ${TARGET_DIR}/etc/inittab
fi

# Automatic login
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^console::respawn:-/bin/sh' ${TARGET_DIR}/etc/inittab || \
	sed -i 's,console::respawn:/sbin/getty -L  console 0 vt100 # GENERIC_SERIAL,console::respawn:-/bin/sh,g' ${TARGET_DIR}/etc/inittab
fi

# Kernel modules via plan9
if [ -e ${TARGET_DIR}/etc/fstab ]; then
    grep -qE '^tag_modules' ${TARGET_DIR}/etc/fstab || \
	echo 'tag_modules	/lib/modules	9p	trans=virtio,version=9p2000.L' >> ${TARGET_DIR}/etc/fstab
fi

# Authorize our SSH public keys by default
if [ ! -e ${TARGET_DIR}/root/.ssh/authorized_keys ]; then
    mkdir -p ${TARGET_DIR}/root/.ssh
    if [ -e ~/.ssh/id_rsa.pub ]; then
	cat ~/.ssh/id_rsa.pub >> ${TARGET_DIR}/root/.ssh/authorized_keys
    fi
    if [ -e ~/.ssh/id_ecdsa.pub ]; then
	cat ~/.ssh/id_ecdsa.pub >> ${TARGET_DIR}/root/.ssh/authorized_keys
    fi
    if [ -e ~/.ssh/id_ed25519.pub ]; then
	cat ~/.ssh/id_ed25519.pub >> ${TARGET_DIR}/root/.ssh/authorized_keys
    fi
fi
