#!/bin/bash 

extlinux=/boot/extlinux/extlinux.conf
BR=$(awk '(/TNSPEC/)&&($0=$2)' /etc/nv_boot_control.conf)
BR=(${BR//-/ })
BR=${BR[2]}
FDT="/boot/dtbs/tegra234-p3768-0000+p3767-${BR}-nv-super-host.dtb"

function bad_case() {
cat << eof
	The device tree ${FDT} is not found.
	Exit w/out the ${extlinux} file update ...
eof
exit 0
}

function good_case() {
cat << eof
	The device tree ${FDT} is found.
	The ${extlinux} file has been updated.
	Reboot is required.
eof
exit 0
}

if [ ! -f ${FDT} ];then
	bad_case
fi

sed -i "/FDT/d" ${extlinux}
sed -i "/root=/i\      FDT ${FDT}" ${extlinux}
good_case
