#!/bin/bash -xe

function get_credentials() {
	if [[ $(id -u) != 0 ]];then
		echo "Permission denied; error exit"
		return 1		
	fi
	return 0
}

function logs_status() {
	local log_path="/var/log"
	local real_path=$(readlink -e ${log_path})
	local logs_dev=$(findmnt ${log_path} -o SOURCE -n)
	if [[ ${logs_dev:-"folder"} = "tmpfs" ]];then
		sed -i 's/\(^.*\/var\/log\)/# \1/g' /etc/fstab
		umount ${log_path} -l 2>/dev/null || true
	fi
	[[ ${real_path} = ${log_path} ]] && return 0 || true
	unlink ${log_path}
	return 0
}

function logs_enable() {
	mkdir -p /var/log/journal || true
	systemd-tmpfiles --create --prefix /var/log/journal || true
cat << eof
	Logs enable done.
	Please reboot the system.
eof
	return 0
}

get_credentials && logs_status && logs_enable
