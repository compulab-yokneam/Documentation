# Intro

* [JetPack 6.2.2 SDK](https://developer.nvidia.com/embedded/jetpack-sdk-622)
* [NVIDIA Jetson Linux 36.5](https://developer.nvidia.com/embedded/jetson-linux-r365)
* [Jetson Linux Release Notes r36.5](https://docs.nvidia.com/jetson/archives/r36.5/ReleaseNotes/Jetson_Linux_Release_Notes_r36.5.pdf)

# Setup environment:

* Make the WorkDir:
```
mkdir jetson-linux-r365 && cd  jetson-linux-r365
export WORKDIR=$(pwd)
```
* Make more directories
```
mkdir downloads sources tools
```

## ToolChain:

* Download the [toolchain](https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v3.0/toolchain/aarch64--glibc--stable-2022.08-1.tar.bz2)
```
wget -P ${WORKDIR}/downloads https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v3.0/toolchain/aarch64--glibc--stable-2022.08-1.tar.bz2
```
* Extract and setup the toolchain
```
tar -xpf ${WORKDIR}/downloads/aarch64--glibc--stable-2022.08-1.tar.bz2 -C ${WORKDIR}/tools
```

## Drivers:
* Download [Driver Package (BSP)](https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v5.0/release/Jetson_Linux_r36.5.0_aarch64.tbz2):
```
wget -P ${WORKDIR}/downloads https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v5.0/release/Jetson_Linux_r36.5.0_aarch64.tbz2
```

* Download [Driver Package (BSP) Sources](https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v5.0/sources/public_sources.tbz2)
```
wget -P ${WORKDIR}/downloads https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v5.0/sources/public_sources.tbz2
```

* Download [Sample Root Filesystem](https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v5.0/release/Tegra_Linux_Sample-Root-Filesystem_r36.5.0_aarch64.tbz2)
```
wget -P ${WORKDIR}/downloads https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v5.0/release/Tegra_Linux_Sample-Root-Filesystem_r36.5.0_aarch64.tbz2
```

# Prepare Build Environment:

* Extract the BSP archive:
```
tar -xpf downloads/Jetson_Linux_r36.5.0_aarch64.tbz2 -C ${WORKDIR}
export L4T_ROOT=${WORKDIR}/Linux_for_Tegra
```
* Go to the source folder and download all sources:
```
cd ${WORKDIR}/Linux_for_Tegra/source
export RELEASE_TAG=jetson_36.5
./source_sync.sh -t ${RELEASE_TAG}
```

# Cross compiler environmnet
```
export ARCH=arm64
export CROSS_COMPILE=${WORKDIR}/tools/aarch64--glibc--stable-2022.08-1/bin/aarch64-buildroot-linux-gnu-
```
# Build
* Goto to the source root and set an ev `KERNEL_HEADERS`
```
cd ${WORKDIR}/Linux_for_Tegra/source
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
mkdir ${WORKDIR}/Linux_for_Tegra/rootfs/{boot/dtbs,lib} -p
export INSTALL_MOD_PATH=${WORKDIR}/Linux_for_Tegra/rootfs/
```

* Issue install into ``rootfs``:
```
export INSTALL_MOD_PATH=${WORKDIR}/Linux_for_Tegra/rootfs/
sudo -E make install -C kernel
sudo -E make modules_install
sudo cp -a kernel-devicetree/generic-dts/dtbs/*-nv-super*.dtb ${INSTALL_MOD_PATH}/boot/dtbs/
sudo cp ${KERNEL_HEADERS}/arch/arm64/boot/Image ${INSTALL_MOD_PATH}/boot/
```

* Copy the device tree files to the ``${L4T_ROOT}/kernel/dtb``:
```
sudo cp -a kernel-devicetree/generic-dts/dtbs/* ${L4T_ROOT}/kernel/dtb/
```

# Flashing the device
  |Revision|Configuration ev|
  |---|---|
  |rev1v1|export EDGE_AI="edge-ai-rev1v1"|
  |rev1v2|export EDGE_AI="edge-ai"|

* The rootfs+bootlader
```
sudo ./tools/kernel_flash/l4t_initrd_flash.sh --external-device nvme0n1p1 \
  -c tools/kernel_flash/flash_l4t_t234_nvme.xml \
  -p "-c bootloader/generic/cfg/flash_t234_qspi.xml" \
  --showlogs --network usb0 ${EDGE_AI:-"edge-ai"} external | tee /tmp/edge-ai-rootfs-bootloader.log
```
* Bootloader
```
sudo ./tools/kernel_flash/l4t_initrd_flash.sh \
  -c tools/kernel_flash/flash_l4t_external.xml \
  -p "-c bootloader/generic/cfg/flash_t234_qspi.xml --no-systemimg" \
  --network usb0 ${EDGE_AI:-"edge-ai"} external | tee /tmp/edge-ai-bootloader.log
```

# Backup & Restore
* Backup
```
sudo ./tools/backup_restore/l4t_backup_restore.sh -b edge-ai
```
* Restore
```
sudo ./tools/backup_restore/l4t_backup_restore.sh -r edge-ai
```

## CompuLab and NVidia resources
* CompuLab development snapshot: https://github.com/compulab-yokneam/edge-ai-linux/blob/devel/README.md
* Yet anover CompuLab resource: https://github.com/compulab-yokneam/compulab-l4t
* Yocto NVidia: https://github.com/OE4T/tegra-demo-distro
* Yocto CompuLab: https://github.com/compulab-yokneam/meta-tegra-compulab
