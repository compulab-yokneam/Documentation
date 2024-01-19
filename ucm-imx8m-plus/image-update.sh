#!/bin/bash

QEMU_STATIC=/usr/bin/qemu-aarch64-static
mnt_point=/tmp/mount.d
MAIN_SCRIPT=${0}
FUNCTION=${1}
IMAGE=${2}
SCRIPT=${3}
SIZE=${3}

_mount() {
	export loop_device=$(losetup --show --find --partscan ${IMAGE})
	mkdir -p ${mnt_point}
	mount ${loop_device}p2 ${mnt_point}
	mount -t proc proc ${mnt_point}/proc
	mount -t sysfs sys ${mnt_point}/sys
	mount -t devtmpfs dev ${mnt_point}/dev
	mount -t devpts devpts ${mnt_point}/dev/pts
	cp ${QEMU_STATIC} ${mnt_point}/bin/
}

_umount() {
	umount ${mnt_point}/dev/pts ${mnt_point}/dev ${mnt_point}/sys ${mnt_point}/proc ${mnt_point}
	losetup --detach ${loop_device}
}

_chroot() {
if [ -f ${SCRIPT:-""} ];then
    cp ${SCRIPT} ${mnt_point}/tmp/
    SCRIPT=/tmp/$(basename ${SCRIPT})
    chmod a+x ${mnt_point}/${SCRIPT}
else
    SCRIPT=""
fi
chroot ${mnt_point} ${SCRIPT}
}

_expand() {
    truncate --size=${SIZE}G ${IMAGE}	
    chroot ${mnt_point} /usr/bin/compulab-resize-part.sh
    /lib/systemd/systemd-growfs ${mnt_point}
}

expand_func() {
	IMAGE=${IMAGE} _mount
	SIZE=${SIZE} _expand
	_umount
}

chroot_func() {
	IMAGE=${IMAGE} _mount
	SCRIPT=${SCRIPT} _chroot
	_umount
}

help_func() {
cat << eof
chroot:
    ${MAIN_SCRIPT} chroot <image-file> <script-to-issue-in-chroot>
    ${MAIN_SCRIPT} chroot <image-file>
expand:
    ${MAIN_SCRIPT} expand <image-file> <size-in-GB>
eof
exit 2
}


FUNCTION=${FUNCTION:-"help"}_func
command -v ${FUNCTION} || FUNCTION="help_func"
[[ -z ${IMAGE:-""} ]] && help_func || true
[[ ! -f ${IMAGE:-""} ]] && help_func || true
IMAGE=${IMAGE} SIZE=${SIZE} SCRIPT=${SCRIPT} ${FUNCTION}
