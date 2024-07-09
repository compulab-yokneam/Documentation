#!/bin/bash -ex

EFI=/boot/efi

function get_current_env() {
	local _current_kernel=$(uname -r)
	local _efi_folder=${EFI}/${_current_kernel}
	mkdir -p ${_efi_folder}	
	fw_printenv fdtfile image mmcpart | tee ${_efi_folder}/.env
cat << eof | tee ${_efi_folder}/.cmd
fw_setenv --script ${_efi_folder}/.env
eof
}

function get_tararch_env() {
	export $(fw_printenv fdtfile)
	export $(tar tvf ${TAR_FILE} | awk -v fdtfile=${fdtfile} -v image=vmlinux '($0~fdtfile)&&($0="fdtfile="$NF)||($0~image)&&($0="image="$NF)')
	export version=$(sed 's/^.*vmlinux-//g' <<< ${image})
	local _current_kernel=${version}
	local _efi_folder=${EFI}/${_current_kernel}
	mkdir -p ${_efi_folder}	
cat << eof | tee ${_efi_folder}/.env
image=${image}
fdtfile=${fdtfile}
mmcpart=2
eof

cat << eof | tee ${_efi_folder}/.cmd
fw_setenv --script ${_efi_folder}/.env
eof
	tar --keep-directory-symlink -C / -xf ${TAR_FILE}

	cat ${_efi_folder}/.env  | awk -F"=" '($0="setenv "$1" "$2)' | tee  ${_efi_folder}/boot.in
	cat /proc/cmdline | awk '$0="setenv bootargs ""\""$0"\""' | tee -a ${_efi_folder}/boot.in
cat << eof | tee -a ${_efi_folder}/boot.in
load mmc 2:2 \${loadaddr} \${image}
load mmc 2:2 \${fdt_addr_r} \${fdtfile}
booti \${loadaddr} - \${fdt_addr_r}
eof
	mkimage -C none -O Linux -A arm -T script -d ${_efi_folder}/boot.in ${_efi_folder}/boot.scr
	cp ${_efi_folder}/boot.scr ${bootp_mp}/
}

function boot_device_init() {
	export bootp_mp=$(mktemp --directory)
	bootp=$(findmnt --noheadings --output=SOURCE /)
	bootp=${bootp:0:-1}1
	umount -l ${bootp} &>/dev/null || true
	mount ${bootp} ${bootp_mp}
	function boot_device_fini() {
		umount ${bootp}
		rm -rf ${bootp_mp}
	}
}

TAR_FILE=${1}

boot_device_init
get_current_env
get_tararch_env
boot_device_fini

cat << eof
Kernel ${version} deployed successfully.
Reboot the system and issue run bsp_bootcmd
eof
