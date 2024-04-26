# Building the CompuLab Linux Kernel on a CompuLab device:

* Prerequisites
```
sudo apt-get install --no-install-recommends make build-essential libncurses-dev bison flex libssl-dev libelf-dev zip unzip
```

## Download the source code:
```
mkdir -p ~/compulab-bsp/src ; cd ~/compulab-bsp/src
bash <(curl -L https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/ucm-imx8m-plus/download_kernel_source.sh)
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
