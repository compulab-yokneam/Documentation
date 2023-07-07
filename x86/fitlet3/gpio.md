# Fitlet3

## GPIO

Fitlet3 features a pca953x gpio extender

## How to

### Interactive

* Registering a new gpio chip
```
MODULES='i2c_smbus i2c_dev'
PCA9555=0x20

for _m in ${MODULES};do
modprobe ${_m}
done

smbus=$(i2cdetect -l | awk '(/smbus/)&&($0=$1)')
echo pca9555 ${PCA9555} > /sys/bus/i2c/devices/${sm_bus}/new_device
GPIO_BASE=$(ls -al /sys/class/gpio/ | awk -v smbus=${smbus} -F"/" '($0~smbus)&&($0=$NF)&&(gsub(/gpiochip/,""))')

cat << eof
PCA9555 start gpio # ${GPIO_BASE}
eof
```

* Using the rigistered gpio chip<br>
Follow the instructions of: https://www.kernel.org/doc/Documentation/gpio/sysfs.txt


* Unregistering device
```
smbus=$(i2cdetect -l | awk '(/smbus/)&&($0=$1)')
echo ${PCA9555} > /sys/bus/i2c/devices/${smbus}/delete_device
```

### Automatic:
* Registering a new gpio chip
```
bash <(curl -Sl https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/x86/fitlet3/gpio_add_ctrl.sh)
```

* Unregistering device
```
bash <(curl -Sl https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/x86/fitlet3/gpio_rem_ctrl.sh)
```
