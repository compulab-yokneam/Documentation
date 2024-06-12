#!/bin/bash -x

function unmount_boot() {
	umount -l ${BOOT_MOUNT_POINT}
}

function mount_boot() {
	local root_device=$(findmnt / --output SOURCE --noheadings)
	local boot_device=${root_device:0:-1}1
	local mount_boot_point=$(findmnt boot_device --output TARGET --noheadings)
	export BOOT_MOUNT_POINT=$(mktemp --directory)
	if [[ -z "${mount_boot_point}" ]];then
		mount ${boot_device} ${BOOT_MOUNT_POINT}
	else
		mount -B ${mount_boot_point} ${BOOT_MOUNT_POINT}
	fi
}

VERSION_STRING=""
function get_version_string() {
	[[ -z "${VERSION_STRING}" ]] || return 0
	dtb=(${dtb//\// })
	VERSION_STRING=${dtb[2]}
}

function update_dtbs() {
	local _dtbsdir=${BOOT_MOUNT_POINT}/dtbs/$(uname -r)
	for _dtb in $(find /boot/ | awk '/\/boot\/dtbs\/.*\/compulab\/iot-/');do
		dtb=${_dtb} get_version_string
		_file=${BOOT_MOUNT_POINT}/$(basename ${_dtb})
		if [[ -f ${_file} ]];then
			diff ${_file} ${_dtb} &>/dev/null && continue
			mkdir -p ${_dtbsdir}
			cp ${_file} ${_dtbsdir}/
		fi
		cp ${_dtb} ${BOOT_MOUNT_POINT}/
	done
	[[ ! -d /boot/dtbs ]] || mv /boot/dtbs /boot/_dtbs
}

function update_image() {
	[[ -n "${VERSION_STRING}" ]] || return 0
	local _kernel_image=/boot/vmlinuz-${VERSION_STRING}
	if [[ -f ${_kernel_image} ]];then
		cat ${_kernel_image} | gunzip -c - > ${BOOT_MOUNT_POINT}/Image-${VERSION_STRING}
		ln -sf Image-${VERSION_STRING} ${BOOT_MOUNT_POINT}/Image
	fi
}

mount_boot
update_dtbs
update_image
unmount_boot
