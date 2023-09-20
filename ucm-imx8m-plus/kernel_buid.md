# Building the CompuLab Linux Kernel on a CompuLab device:

* Prerequisites
```
sudo apt install make build-essential libncurses-dev bison flex libssl-dev libelf-dev zip
```

## Download and deploy the source code:
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

## Building the Debian Package
```
make -j `nproc` bindeb-pkg
```

## Issue Kernel Debian Package install
```
sudo dpkg -i ../linux-headers-5.15.32_5.15.32-1_arm64.deb ../linux-image-5.15.32_5.15.32-1_arm64.deb ../linux-libc-dev_5.15.32-1_arm64.deb
```
