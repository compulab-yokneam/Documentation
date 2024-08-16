#!/bin/bash -ex

function issue_qemu() {
qemu-system-aarch64 -smp 8 -m 1024 -cpu cortex-a53 \
	-machine type=virt,gic-version=3 \
	-kernel ${KERNEL_IMAGE} \
	-display none \
	-serial tcp::4446,server,telnet \
	-drive if=none,file=${ROOTFS_IMAGE},id=foo,format=raw \
	-device virtio-blk-device,drive=foo \
	-append 'root=/dev/vda rw console=ttyAMA0 rootwait earlyprintk' \
	-monitor stdio
}

function issue_init() {
	export mpoint=$(mktemp --dry-run --quiet)
	export loop_device=$(sudo losetup --show --find --partscan ${IMAGE_FILE})
	mkdir -p ${mpoint} 
	mount -o ro ${loop_device}p1 ${mpoint}
	export KERNEL_IMAGE=${mpoint}/Image
	export ROOTFS_IMAGE=${loop_device}p2
	return 0
}

function issue_fini() {
	umount -l ${mpoint} || true
	losetup --detach ${loop_device} || true
	rm -rf ${mpoint} || true
	return 0
}

SCRIPT_FULL_PATH=$(readlink -e ${BASH_SOURCE[0]})
function issue_help() {
cat << eof
	Error: ${ERROR_MSG}
	sudo ${SCRIPT_FULL_PATH} ${IMAGE_FILE}
eof
	exit 1
}


IMAGE_FILE=${1:-"/path/to/os.image"}

[[ $(id --user) -eq 0 ]] || { ERROR_MSG="Insufficient permissions; run with sudo" issue_help; }
[[ -f ${IMAGE_FILE} ]] || { ERROR_MSG="File ${IMAGE_FILE} not found" issue_help; }
file ${IMAGE_FILE} | grep -q "DOS\/MBR boot sector" || {  ERROR_MSG="File ${IMAGE_FILE} is not an OS image file" issue_help; }

issue_init
issue_qemu
issue_fini
