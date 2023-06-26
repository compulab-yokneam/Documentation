# Fitlet3

## GPIO

Fitlet3 features a pca953x gpio extender

## How to

### Interactive

* Registering a new gpio chip
```
MODULES='i2c_smbus i2c_i80i i2c_dev'

PCA9555=0x20

for _m in ${MODULES};do
modprobe ${_m}
done

sm_bus=$(i2cdetect -l | awk '(/smbus/)&&($0=$1)')

echo pca9555 ${PCA9555} > /sys/bus/i2c/devices/${sm_bus}/new_device

ls -al /sys/class/gpio/|grep ${sm_bus} 

GPIO_BASE=$(ls -al /sys/class/gpio/ | awk -F"/" '(/i2c-2/)&&($0=$NF)&&(gsub(/gpiochip/,""))')

cat << eof
PCA9555 start gpio # ${GPIO_BASE}

eof
```

* Using the rigistered gpio chip<br>
Follow the instructions of: https://www.kernel.org/doc/Documentation/gpio/sysfs.txt


* Unregistering device
```
sm_bus=$(i2cdetect -l | awk '(/smbus/)&&($0=$1)')
echo 0x20 > /sys/bus/i2c/devices/${sm_bus}/delete_device
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
