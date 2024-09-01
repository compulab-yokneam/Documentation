#!/bin/bash -ex

SWD=$(dirname ${BASH_SOURCE[0]})
source ${SWD}/common.inc

umount /mnt/${ENCVOLUME}
dmsetup remove ${ENCVOLUME}
losetup -D
modprobe dm_crypt -r
modprobe trusted -r
