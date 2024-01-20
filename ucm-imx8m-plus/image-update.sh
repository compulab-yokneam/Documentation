#!/bin/bash

QEMU_STATIC=/usr/bin/qemu-aarch64-static
mnt_point=/tmp/mount.d
FULL_ARGS=$@
MAIN_SCRIPT=${0}
FUNCTION=${1}
IMAGE=${2}
SCRIPT=${3}
SIZE=${3}

_admin_req() {
    [[ $(id -u) == 0 ]] && return 0 || true
cat << eof
    Administration privileges are required;
    issue:
        sudo ${MAIN_SCRIPT} ${FULL_ARGS}
eof
   exit 1
}

_qemu_req() {
    [[ -f ${QEMU_STATIC} ]] && return 0 || true
cat << eof
    ${QEMU_STATIC} is not found;
    issue:
        sudo apt-get update
        sudo apt-get qemu-user-static
eof
    exit 1
}

_bind_mount() {
    declare -A mounto=([proc]='-t proc proc' [sys]='-t sysfs sys' [dev]='-t devtmpfs dev' [dev/pts]='-t devpts devpts')
    local mpoints="sys proc dev dev/pts"
    for d in ${mpoints}; do
        mpoint=$(readlink -f ${mnt_point}/${d})
        findmnt ${mpoint} &>/dev/null || mount ${mounto[${d}]} ${mnt_point}/${d}
    done
}

_bind_umount() {
    local mpoints="dev/pts dev proc sys"
    for d in ${mpoints}; do
	if [[ -d ${mnt_point}/${d} ]];then
        mpoint=$(readlink -f ${mnt_point}/${d})
        while [ 1 ];do
            findmnt ${mpoint} &>/dev/null && umount ${mpoint} || break
        done
	fi
    done
}

_qemu_add() {
	cp ${QEMU_STATIC} ${mnt_point}/bin/
}

_qemu_rem() {
	rm ${mnt_point}/${QEMU_STATIC}
}

_mount() {
	export loop_device=$(losetup --show --find --partscan ${IMAGE})
	mkdir -p ${mnt_point}
	mount ${loop_device}p2 ${mnt_point}
	_bind_mount
	_qemu_add
}

_umount() {
	_qemu_rem
	_bind_umount
	umount ${mnt_point}
	losetup --detach ${loop_device}
}

_chroot() {
if [ -f ${SCRIPT:-""} ];then
    cp ${SCRIPT} ${mnt_point}/tmp/
    SCRIPT=/tmp/$(basename ${SCRIPT})
    chmod a+x ${mnt_point}/${SCRIPT}
else
    SCRIPT="tmux"
fi
chroot ${mnt_point} ${SCRIPT}
}

_expand() {
    truncate --size=${SIZE}G ${IMAGE}	
    chroot ${mnt_point} /usr/bin/compulab-resize-part.sh || true
    /lib/systemd/systemd-growfs ${mnt_point}
}

expand_func() {
	local _image_size=$(($(stat --format=%s ${IMAGE})>>30))
	if [[ ${SIZE} -lt ${_image_size} ]];then
cat << eof
	Image size is ${_image_size} > ${SIZE}
	shrink mode is not supported
eof
		exit 1
	fi
	if [[ ${SIZE} -eq ${_image_size} ]];then
cat << eof
	Image size ${_image_size} == ${SIZE}
	Nothing to expand
eof
		exit 0
	fi
	IMAGE=${IMAGE} _mount
	IMAGE=${IMAGE} SIZE=${SIZE} _expand
	_umount
}

chroot_func() {
	IMAGE=${IMAGE} _mount
	IMAGE=${IMAGE} SCRIPT=${SCRIPT} _chroot
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

_admin_req
_qemu_req

FUNCTION=${FUNCTION:-"help"}_func
command -v ${FUNCTION} || FUNCTION="help_func"
[[ -z ${IMAGE:-""} ]] && help_func || true
[[ ! -f ${IMAGE:-""} ]] && help_func || true
IMAGE=${IMAGE} SIZE=${SIZE} SCRIPT=${SCRIPT} ${FUNCTION}
