#!/bin/bash -xe

function get_credentials() {
	if [[ $(id -u) != 0 ]];then
		echo "Permission denied; error exit"
		return 1		
	fi
	return 0
}

function logs_status() {
	local logs_dev=$(findmnt /var/log -o SOURCE -n)
	if [[ ${logs_dev:-"folder"} != "tmpfs" ]];then
		echo "/var/log is a folder; most likely the logs already enabled"
		return 1
	fi
	return 0
}

function logs_enable() {
	sed -i 's/\(^.*\/var\/log\)/# \1/g' /etc/fstab
	umount /var/log -l 2>/dev/null || true
	mkdir -p /var/log/journal || true
	systemd-tmpfiles --create --prefix /var/log/journal || true
cat << eof
	Logs enable done.
	Please reboot the system.
eof
	return 0
}

get_credentials && logs_status && logs_enable
