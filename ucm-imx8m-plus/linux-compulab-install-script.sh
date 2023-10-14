#!/bin/bash -x

kernel_release_file=include/config/kernel.release
if [[ ! -f ${kernel_release_file} ]];then
cat << eof
        The ${BASH_SOURCE[0]} is running in a wrong directory $(pwd)
        File: $(pwd)/${kernel_release_file} not found
        Exiting ...
eof
exit 2
fi

R=$(cat ${kernel_release_file})
FAKEROOT=/tmp/linux-compulab/kernel-${R}

INSTALL_MOD_PATH=${INSTALL_MOD_PATH:-${FAKEROOT}}

mkdir -p ${INSTALL_MOD_PATH}/boot

export INSTALL_MOD_PATH=${INSTALL_MOD_PATH} INSTALL_PATH=${INSTALL_MOD_PATH}/boot

kernel_rootfs_install() {
        make install modules_install
        cp -v arch/arm64/boot/Image ${INSTALL_PATH}/Image-${R}
        cp -v arch/arm64/boot/dts/compulab/*.dtb ${INSTALL_PATH}/
        return 0
}

kernel_boot_update() {
# Exit if INSTALL_PATH is not /boot
        local _boot=$(readlink -e ${INSTALL_PATH})
        [[ "${_boot}" = "/boot" ]] || return 1

# Exit root device is not mounted
        local r=$(findmnt / -no SOURCE)
        [[ "${r}" ]] || return 1

# Exit boot device is not a separate block device
        local b=${r:0:-1}1
        [[ "${r}" != "${b}" ]] || return 0

# Exit boot device is not a block device
        [[ -b "${b}" ]] || return 1

# Unmount boot if mounted
        bmnt=$(mount | grep ${b} | awk '$0=$3')
        [[ "${bmnt}" ]] && umount -l ${bmnt}

        local _bmnt=$(mktemp --directory)
        mount ${b} ${_bmnt}
        cp -v ${INSTALL_PATH}/Image-${R} ${INSTALL_PATH}/*.dtb ${_bmnt}
        umount ${_bmnt}
        sync;sync;sync
        rm -rf ${_bmnt}


# Mount back if was unmounted
        [[ "${bmnt}" ]] && mount ${b} ${bmnt}

        return 0
}

kernel_boot_environment_update() {
        fw_setenv image Image-${R}
}

kernel_rootfs_install
kernel_boot_update && kernel_boot_environment_update || true
