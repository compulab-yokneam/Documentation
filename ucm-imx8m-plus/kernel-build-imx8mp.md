# Building the CompuLab Linux Kernel on a CompuLab device

* Prerequisites
```
sudo apt install make build-essential libncurses-dev bison flex libssl-dev libelf-dev zip
```

* Supported CompuLab machines: `ucm-imx8m-plus, som-imx8m-plus, iot-gate-imx8plus`

* Supported linux-compuLab versions:

| Version number | Environment Variable |
|---|---|
|5.15.32|```export CL_VERSION=5.15.32```|
|5.15.71|```export CL_VERSION=5.15.71```|
|6.1.22|```export CL_VERSION=6.1.22```|

## Download the Linux kernel source code:
```
CL_VERSION=${CL_VERSION} bash <(wget -O - https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/ucm-imx8m-plus/linux-compulab-kernel-downlad-src.sh)
```

## Goto the kernel source location:
```
cd /usr/src/linux-compulab-linux-compulab_v${CL_VERSION}
```

## Apply the CompuLab machine configuration:
```
make compulab_v8_defconfig compulab.config
```

## Customize the kernel configuration if required:
```
make menuconifg
```

## Issue kernel build:
```
make -j `nproc`
```

## Issue kernel install:
```
INSTALL_MOD_PATH=/ bash <(wget -O - https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/ucm-imx8m-plus/linux-compulab-kernel-install-script.sh)
```
