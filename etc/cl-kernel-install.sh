#!/bin/bash -ex

EFI=/boot/kernel-backup.d

function save_current_env() {
	local _current_kernel=$(uname -r)
	local _efi_folder=${EFI}/${_current_kernel}
	[[ ! -d ${_efi_folder} ]] || return 0
	mkdir -p ${_efi_folder}
	cp ${bootp_mp}/{Image*,*.dtb*,kernel*,config*} ${_efi_folder}/ &>/dev/null || true
	export $(fw_printenv fdtfile image)
	export $(find ${_efi_folder} | awk -v fdtfile=${fdtfile} -v image=${image} '($0~fdtfile)&&($0="fdtfile="$NF)||($0~image)&&($0="image="$NF)')
	(for value in fdtfile image;do echo "setenv ${value} ${!value}"; done) | tee ${_efi_folder}/boot.in
cat << eof | tee -a ${_efi_folder}/boot.in
setenv boot_part 2
setenv part 2
eof
cat << eof | tee ${_efi_folder}/.boot.cmd
command -v mkimage || return
mkimage -C none -O Linux -A arm -T script -d ${_efi_folder}/boot.in ${_efi_folder}/boot.scr || return
cp ${_efi_folder}/boot.scr ${bootp_mp}/boot.${_current_kernel}.scr
eof
	source ${_efi_folder}/.boot.cmd || true
}

function cleanup_current_env() {
	rm ${bootp_mp}/{Image*,*.dtb*,kernel*,config*}
}

function set_new_env() {
	export $(fw_printenv fdtfile)
	export $(tar --keep-directory-symlink -C / -xvf ${TAR_FILE} | awk -v fdtfile=${fdtfile} -v image=vmlinuz '($0~fdtfile)&&($0="fdtfile="$NF)||($0~image)&&($0="image="$NF)')
	export version=${image/*vmlinuz-/}
	cat /${image} | gunzip -c - > ${bootp_mp}/Image-${version}
	ln -sf Image-${version} ${bootp_mp}/Image || mv ${bootp_mp}/Image-${version} ${bootp_mp}/Image
	cp $(dirname /${fdtfile})/*.dtb* ${bootp_mp}
}

function boot_device_init() {
	export bootp_mp=$(mktemp --directory)
	bootp=$(findmnt --noheadings --output=SOURCE /)
	bootp=${bootp:0:-1}1
	umount -l ${bootp} &>/dev/null || true
	mount ${bootp} ${bootp_mp}
}

function boot_device_fini() {
	umount ${bootp}
	rm -rf ${bootp_mp}
}

TAR_FILE=${1}

boot_device_init
save_current_env
cleanup_current_env
set_new_env
boot_device_fini

cat << eof
Kernel ${version} deployed successfully.
Reboot the system and issue run bsp_bootcmd
eof
