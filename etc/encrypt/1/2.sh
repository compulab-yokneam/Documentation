#!/bin/bash -x

SWD=$(dirname ${BASH_SOURCE[0]})
source ${SWD}/common.inc

function create_image() {
mkdir -p $(dirname ${IMAGE})
[[ -f ${IMAGE} ]] || fallocate --length $((BLOCKS*512)) ${IMAGE}
export DEV=$(losetup --show --find ${IMAGE})
}

function mount_volume() {
TABLE="0 $BLOCKS $TARGET $ALGO :32:trusted:$KEYNAME 0 $DEV 0 1 allow_discards"

cat <<< $TABLE | dmsetup create ${ENCVOLUME}
cat <<< $TABLE | dmsetup load ${ENCVOLUME}

mkdir -p /mnt/${ENCVOLUME}
mount /dev/mapper/${ENCVOLUME} /mnt/${ENCVOLUME} && return 0 || true
mkfs.ext4 -L ${ENCVOLUME}-loop-device /dev/mapper/${ENCVOLUME}
mount /dev/mapper/${ENCVOLUME} /mnt/${ENCVOLUME}
}

create_image
mount_volume
