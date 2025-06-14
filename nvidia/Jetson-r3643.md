# Start from here
https://developer.nvidia.com/embedded/jetson-linux-r3643
## Setup environment:
* Make the WorkDir:
```
mkdir jetson-linux-r3643 && cd  jetson-linux-r3643
export WORKDIR=$(pwd)
```
* Make more directories
```
mkdir downloads sources tools
```
* Download the [toolchain](https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v3.0/toolchain/aarch64--glibc--stable-2022.08-1.tar.bz2)
```
cd ${WORKDIR}
wget -P downloads https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v3.0/toolchain/aarch64--glibc--stable-2022.08-1.tar.bz2
```
* Extract and setup the toolchain
```
tar -xpf ${WORKDIR}/downloads/aarch64--glibc--stable-2022.08-1.tar.bz2 -C ${WORKDIR}/tools
```
* Download [Driver Package (BSP)](https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v4.3/release/Jetson_Linux_r36.4.3_aarch64.tbz2):
```
cd ${WORKDIR}
wget -P downloads https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v4.3/release/Jetson_Linux_r36.4.3_aarch64.tbz2
```
* Extract the BSP archive:
```
cd ${WORKDIR}
tar -xpf downloads/Jetson_Linux_r36.4.3_aarch64.tbz2 -C sources
```
* Go to the source folder and download all sources:
```
cd ${WORKDIR}/sources/Linux_for_Tegra/source
export RELEASE_TAG=jetson_36.4.3
./source_sync.sh -t ${RELEASE_TAG}
```

# Environmnet
```
export ARCH=arm64
export CROSS_COMPILE=${WORKDIR}/tools/aarch64--glibc--stable-2022.08-1/bin/aarch64-buildroot-linux-gnu-
```
# Build
* Goto to the source root and set an ev `KERNEL_HEADERS`
```
cd ${WORKDIR}/sources/Linux_for_Tegra/source
export KERNEL_HEADERS=${PWD}/kernel/kernel-jammy-src
```

* Issue full build
```
make -j 16 -C kernel
make -j 16 modules
make -j 16 dtbs
```
# Install

* Prepare destination
```
mkdir ${WORKDIR}/sources/Linux_for_Tegra/rootfs/{boot,lib} -p
export INSTALL_MOD_PATH=${WORKDIR}/sources/Linux_for_Tegra/rootfs/
```

* Issue install
```
export INSTALL_MOD_PATH=${WORKDIR}/sources/Linux_for_Tegra/rootfs/
sudo -E make install -C kernel
sudo -E make modules_install
sudo cp -a kernel-devicetree/generic-dts/dtbs ${INSTALL_MOD_PATH}/boot/
```
