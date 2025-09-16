#!/bin/sh

# Automatic login
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^console::respawn:-/bin/sh' ${TARGET_DIR}/etc/inittab || \
	sed -i 's,console::respawn:/sbin/getty -L  console 0 vt100 # GENERIC_SERIAL,console::respawn:-/bin/sh,g' ${TARGET_DIR}/etc/inittab
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
