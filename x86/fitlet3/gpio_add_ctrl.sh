#!/bin/bash

MODULES='i2c_smbus i2c_dev'
PCA9555=0x20

for _m in ${MODULES};do
modprobe ${_m} 2>/dev/null || true
done

smbus=$(i2cdetect -l | awk '(/smbus/)&&($0=$1)')
echo pca9555 ${PCA9555} > /sys/bus/i2c/devices/${smbus}/new_device
GPIO_BASE=$(ls -al /sys/class/gpio/ | awk -v smbus=${smbus} -F"/" '($0~smbus)&&($0=$NF)&&(gsub(/gpiochip/,""))')

cat << eof
PCA9555 start gpio # ${GPIO_BASE}
eof
