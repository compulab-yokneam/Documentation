#!/bin/bash

PCA9555=0x20

smbus=$(i2cdetect -l | awk '(/smbus/)&&($0=$1)')
echo ${PCA9555} > /sys/bus/i2c/devices/${smbus}/delete_device
