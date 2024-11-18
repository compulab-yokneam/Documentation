#!/bin/bash

set -x
uname -r
lspci -k
modprobe iwlmvm -r
modprobe iwlwifi -r
dmesg -c > /dev/null
modprobe iwlwifi
sleep 3
dmesg -T
ls -al /sys/class/net/
ip a
find /lib/firmware
zcat /proc/config.gz
