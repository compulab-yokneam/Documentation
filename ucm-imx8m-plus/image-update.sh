#!/bin/bash

QEMU_STATIC=qemu-aarch64-static
GROWFS=/lib/systemd/systemd-growfs
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

declare -A _anonymous_req_array=()
_anonymous_req_array+=(["qemu-aarch64-static"]="qemu-user-static")
_anonymous_req_array+=(["e2fsck"]="e2fsprogs")
_anonymous_req_array+=(["resize2fs"]="e2fsprogs")
_anonymous_req_array+=(["parted"]="parted")
_anonymous_req_array+=(["fdisk"]="fdisk")
_anonymous_req_array+=(["truncate"]="coreutils")
_anonymous_req() {
    for _prog in $@;do
        command -v ${_prog} &>/dev/null && rc=$? || rc=$?
        if [[ ${rc} -ne 0 ]];then
cat << eof
    ${_prog} is not found;
    issue:
        sudo apt-get update
        sudo apt-get ${_anonymous_req_array[$_prog]}
eof
        exit 1
        fi
    done
}

_sw_req() {
    _anonymous_req ${!_anonymous_req_array[@]}
}

_bind_mount() {
    declare -A mounto=([proc]='-t proc proc' [sys]='-t sysfs sys' [dev]='-t devtmpfs dev' [dev/pts]='-t devpts devpts')
    local mpoints="sys proc dev dev/pts"
    for d in ${mpoints}; do
        mpoint=$(readlink -e ${mnt_point}/${d})
        findmnt ${mpoint} &>/dev/null || mount ${mounto[${d}]} ${mnt_point}/${d}
    done
}

_bind_umount() {
    local mpoints="dev/pts dev proc sys"
    for d in ${mpoints}; do
	if [[ -d ${mnt_point}/${d} ]];then
        mpoint=$(readlink -e ${mnt_point}/${d})
        while [ 1 ];do
            findmnt ${mpoint} &>/dev/null && umount ${mpoint} || break
        done
	fi
    done
}

_qemu_add() {
    cp $(which ${QEMU_STATIC}) ${mnt_point}/bin/
}

_qemu_rem() {
    rm ${mnt_point}/bin/${QEMU_STATIC}
}

_loop_device_init() {
    export loop_device=$(losetup --show --find --partscan ${IMAGE})
}

_loop_device_fini() {
    losetup --detach ${loop_device}
}

_mount() {
    mkdir -p ${mnt_point}
    mount ${loop_device}p2 ${mnt_point}
    _bind_mount
    _qemu_add
}

_umount() {
    _qemu_rem
    _bind_umount
    umount ${mnt_point}
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

_resize_fs() {
    if [[ -z ${device_to_resize:-""} ]];then
        echo "no device provided"
        return 0;
    fi

    device_to_resize=$(basename ${device_to_resize})
    part2resize=${part2resize:-${device_to_resize: -1}}

    linux_storage_device=/dev/$(basename $(dirname /sys/class/block/*/${device_to_resize}))

    echo "w" | fdisk ${linux_storage_device} &> /dev/null || true

    echo "Yes" | parted ---pretend-input-tty ${linux_storage_device} resizepart ${part2resize} 100% || true
    e2fsck -f /dev/${device_to_resize}
    resize2fs /dev/${device_to_resize}
}

_expand_prepend() {
    local _image_size=$(($(stat --format=%s ${IMAGE})>>30))
    if [[ ${SIZE} -lt ${_image_size} ]];then
cat << eof
    Image size ${_image_size} > ${SIZE}
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
    return 0
}

_expand() {
    device_to_resize=${loop_device}p2 _resize_fs
    IMAGE=${IMAGE} _mount
    ${GROWFS} ${mnt_point} || true
    _umount
}

expand_func() {
    _expand_prepend
    truncate --size=${SIZE}G ${IMAGE}
    _loop_device_init
    IMAGE=${IMAGE} SIZE=${SIZE} _expand
    _loop_device_fini
}

chroot_func() {
    _loop_device_init
    IMAGE=${IMAGE} _mount
    IMAGE=${IMAGE} SCRIPT=${SCRIPT} _chroot
    _umount
    _loop_device_fini
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
_sw_req

FUNCTION=${FUNCTION:-"help"}_func
command -v ${FUNCTION} || FUNCTION="help_func"
[[ -z ${IMAGE:-""} ]] && help_func || true
[[ ! -f ${IMAGE:-""} ]] && help_func || true
IMAGE=${IMAGE} SIZE=${SIZE} SCRIPT=${SCRIPT} ${FUNCTION}
