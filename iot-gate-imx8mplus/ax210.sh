#!/bin/bash -x

FW_DEB="https://github.com/compulab-yokneam/bin/raw/ax210/linux-firmware-ax210_20231030-r0_all.deb"
FW_FILE=$(basename ${FW_DEB})

function fw_get() {
	rm -rf /tmp/${FW_FILE}
	wget --directory-prefix /tmp ${FW_DEB}
	dpkg -i /tmp/${FW_FILE}
	rm -rf /tmp/${FW_FILE}
}

function fw_sync() {
	ind=($(stat --format=%i /lib/firmware /usr/lib/firmware | awk ''1 ORS=" "))
	if [ ${ind[0]} -ne ${ind[1]} ];then
		tar -C /usr/lib/firmware -cf - . | tar -C /lib/firmware -xf -
	fi
}

fw_get
fw_sync
