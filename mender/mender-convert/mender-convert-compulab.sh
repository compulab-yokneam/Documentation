#!/bin/bash -xv

BINFMT=/usr/lib/systemd/systemd-binfmt
CONFIG=configs/compulab_debian_64bit_config
IMAGE=${IMAGE:-"input/debian-bookworm-arm64.img"}

function compulab_config() {
cat << EOF
source configs/mender_convert_config

MENDER_IGNORE_MISSING_EFI_STUB=1
MENDER_STORAGE_TOTAL_SIZE_MB=12000
MENDER_ENABLE_PARTUUID=y
MENDER_BOOT_PART="/dev/disk/by-partuuid/00000001-0001-0001-0001-000000000001"
MENDER_ROOTFS_PART_A="/dev/disk/by-partuuid/00000002-0002-0002-0002-000000000002"
MENDER_ROOTFS_PART_B="/dev/disk/by-partuuid/00000003-0003-0003-0003-000000000003"
MENDER_DATA_PART="/dev/disk/by-partuuid/00000004-0004-0004-0004-000000000004"

MENDER_CLIENT_DATA_DIR_SERVICE_URL="https://raw.githubusercontent.com/mendersoftware/\
meta-mender/refs/tags/scarthgap-v2024.07/meta-mender-core/recipes-mender/mender-client/files/mender-data-dir.service"

MENDER_COMPRESS_DISK_IMAGE="none"
MENDER_COPY_BOOT_GAP="none"
# TBD
# MENDER_GRUB_D_INTEGRATION="y"

function compulab_modify_hook() {
    sed 's/\(set console_bootargs\).*/\1="console=ttymxc1,115200 console=tty0,115200n8"/' work/boot/EFI/BOOT/grub.cfg > work/boot/efi/boot/grub.cfg
    true
}
PLATFORM_MODIFY_HOOKS+=(compulab_modify_hook)
EOF
}

function compulab_init() {
[[ ! -f ${BINFMT} ]] || chmod 0644 ${BINFMT}
compulab_config > ${CONFIG}
}

function compulab_fini() {
[[ ! -f ${BINFMT} ]] || chmod 0755 ${BINFMT}
rm -rf ${CONFIG}
}

compulab_init

MENDER_ARTIFACT_NAME=release-1 ./mender-convert \
   --disk-image ${IMAGE} \
   --config ${CONFIG} \
   --overlay input/rootfs_overlay_demo

compulab_fini
