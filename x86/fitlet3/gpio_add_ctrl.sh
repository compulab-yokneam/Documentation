#!/bin/bash

MODULES='i2c_smbus i2c_i80i i2c_dev'
PCA9555=0x20

for _m in ${MODULES};do
modprobe ${_m} 2>/dev/null || true
done

sm_bus=$(i2cdetect -l | awk '(/smbus/)&&($0=$1)')

echo pca9555 ${PCA9555} > /sys/bus/i2c/devices/${sm_bus}/new_device

GPIO_BASE=$(ls -al /sys/class/gpio/ | awk -F"/" '(/i2c-2/)&&($0=$NF)&&(gsub(/gpiochip/,""))')

cat << eof
PCA9555 start gpio # ${GPIO_BASE}
eof
