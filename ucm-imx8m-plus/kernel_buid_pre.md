# Building the CompuLab Linux Kernel on a CompuLab device

* Prerequisites
```
sudo apt install make build-essential libncurses-dev bison flex libssl-dev libelf-dev zip
```

## Download and deploy the source code
```
wget -P /tmp/ https://github.com/compulab-yokneam/linux-compulab/archive/refs/heads/linux-compulab_v5.15.32.zip
unzip -d /usr/src /tmp/linux-compulab_v5.15.32.zip
cd /usr/src/linux-compulab-linux-compulab_v5.15.32
```

## Apply the CompuLab default configuration
* Set a CompuLab machine:

| Machine | Command Line |
|---|---|
|ucm-imx8m-plus|```export MACHINE=ucm-imx8m-plus```|
|som-imx8m-plus|```export MACHINE=som-imx8m-plus```|
|iot-gate-imx8plus|```export MACHINE=iot-gate-imx8plus```|

* Add imx-sdma firmware (optonal):
```
wget -O - --no-check-certificate https://github.com/compulab-yokneam/bin/raw/linux-firmware/imx-sdma-20230404.tar.bz2 | tar -xjvf -
wget -O - --no-check-certificate https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx8mp/kirkstone-2.2.0/recipes-kernel/linux/compulab/5.15.32/imx8mp/linux-firmware-sdma.cfg >> arch/arm64/configs/compulab.config
```

* Apply the CompuLab machine configuration:
```
make ${MACHINE}_defconfig compulab.config
```

## Customize the kernel configuration
```
make menuconifg
```

## Issue Kernel build
```
make -j `nproc`
```

## Issue Kernel install
```
make -j `nproc` install modules_install
```

## Update the boot partition
```
mount /dev/mmcblk2p1 /boot
make -j `nproc` install
```
