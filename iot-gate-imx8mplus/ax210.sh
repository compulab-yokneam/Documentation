#!/bin/bash -x

FW_DEB="https://github.com/compulab-yokneam/bin/raw/ax210/linux-firmware-ax210_20231030-r0_all.deb"
FW_FILE=$(basename ${FW_DEB})

rm -rf /tmp/${FW_FILE}
wget --directory-prefix /tmp ${FW_DEB}
dpkg -i /tmp/${FW_FILE}
rm -rf /tmp/${FW_FILE}
