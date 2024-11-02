#!/bin/bash -e

UBOOT_ENV_IN=u-boot-initial-env-sd
UBOOT_ENV_OFFSET=8064
UBOOT_ENV_SIZE=16384

IMX_BOOT=imx-boot-tagged
# emmc offset is 0
IMX_BOOT_OFFSET=0
# sd-card offset is 64
# IMX_BOOT_OFFSET=64
IMX_BOOT_FULL=${IMX_BOOT}-with-env
IMX_BOOT_FULL_SIZE=8192

dd if=/dev/zero    of=${IMX_BOOT_FULL} bs=512 count=${IMX_BOOT_FULL_SIZE} 2>/dev/null
dd if=${IMX_BOOT}  of=${IMX_BOOT_FULL} bs=512 seek=${IMX_BOOT_OFFSET} conv=notrunc 2>/dev/null
cat ${UBOOT_ENV_IN} | mkenvimage -s ${UBOOT_ENV_SIZE} | dd of=${IMX_BOOT_FULL} bs=512 seek=${UBOOT_ENV_OFFSET} conv=notrunc 2>/dev/null

cat << eof

The created file is:
$(readlink -e ${IMX_BOOT_FULL})

How to flash:
sudo uuu -v -d -b emmc $(readlink -e ${IMX_BOOT_FULL})

eof
