#!/bin/bash -ex

umount /mnt/encrypted
dmsetup remove encrypted
losetup -D
modprobe dm_crypt -r
modprobe trusted -r
