#!/bin/bash -x

IMAGE=/data/encrypted1-volume1.img
ALGO="capi:tk(cbc(aes))-plain"
KEYNAME=dm_trust
BLOCKS=262144
TARGET=crypt

function create_image() {
[[ -f ${IMAGE} ]] || fallocate --length $((BLOCKS*512)) ${IMAGE}
export DEV=$(losetup --show --find ${IMAGE})
}

function mount_volume() {
TABLE="0 $BLOCKS $TARGET $ALGO :36:logon:logkey: 0 $DEV 0 1  sector_size:512"

cat <<< $TABLE | dmsetup create encrypted1
cat <<< $TABLE | dmsetup load encrypted1

mkdir -p /mnt/encrypted1
mount /dev/mapper/encrypted1 /mnt/encrypted1 || ( mkfs.ext4 -L encrypted1-loop-device /dev/mapper/encrypted1; mount /dev/mapper/encrypted1 /mnt/encrypted1 )
}

create_image
mount_volume
