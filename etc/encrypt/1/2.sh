#!/bin/bash -x

IMAGE=/data/encrypted-volume.img
ALGO="capi:cbc(aes)-plain"
KEYNAME=dm_trust
BLOCKS=262144
TARGET=crypt

function create_image() {
[[ -f ${IMAGE} ]] || fallocate --length $((BLOCKS*512)) ${IMAGE}
export DEV=$(losetup --show --find ${IMAGE})
}

function mount_volume() {
TABLE="0 $BLOCKS $TARGET $ALGO :32:trusted:$KEYNAME 0 $DEV 0 1 allow_discards"

cat <<< $TABLE | dmsetup create encrypted
cat <<< $TABLE | dmsetup load encrypted

mkdir -p /mnt/encrypted
mount /dev/mapper/encrypted /mnt/encrypted || ( mkfs.ext4 -L encrypted-loop-device /dev/mapper/encrypted; mount /dev/mapper/encrypted /mnt/encrypted )
}

create_image
mount_volume
