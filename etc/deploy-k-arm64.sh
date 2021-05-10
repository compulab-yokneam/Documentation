#!/bin/bash

if [ -d $1 ]
then
    export INSTALL_MOD_PATH=$1
else
    echo "Invalid target dir [ "$1" ]"
    exit
fi

#set -e
ODIR=Debug
KERNEL_RELEASE=$(awk -F"-" ''1 ./${ODIR}/include/config/kernel.release)
KERNEL_VERSION=$(awk -F"-" '$0=$1' ./${ODIR}/include/config/kernel.release)

[[ -z ${TFTP_DIR} ]] && TFTP_DIR=/var/lib/tftpboot/${PP}

mkdir -p ${INSTALL_MOD_PATH}/lib/modules
make modules_install O=./${ODIR}

# sudo mkdir -p ${INSTALL_MOD_PATH}/lib/modules
unlink ${INSTALL_MOD_PATH}/lib/modules/${KERNEL_RELEASE}/build
unlink ${INSTALL_MOD_PATH}/lib/modules/${KERNEL_RELEASE}/source

echo "Directory : ${INSTALL_MOD_PATH}"

sudo chown -R root:root ${INSTALL_MOD_PATH}/lib/modules/

sudo mkdir -p $INSTALL_MOD_PATH/boot
sudo cp ./${ODIR}/arch/arm64/boot/Image $INSTALL_MOD_PATH/boot/Image
sudo ln -vf $INSTALL_MOD_PATH/boot/Image $INSTALL_MOD_PATH/boot/Image${suffix}

for dtb in $(awk -F"=" '(/dtb-\$/)&&($0=$2)' ORS=" " arch/arm64/boot/dts/compulab/Makefile);do
dtb_file=${ODIR}/arch/arm64/boot/dts/compulab/${dtb}
if [[ -f ${dtb_file} ]];then
sudo cp -v ${dtb_file} ${INSTALL_MOD_PATH}/boot/
fi
done

sudo ln -vfs Image-${KERNEL_RELEASE} ${TFTP_DIR}/Image-${PP}

exit 0
