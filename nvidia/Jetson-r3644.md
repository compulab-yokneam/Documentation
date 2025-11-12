# Intro

* NVidia Jetson Linux: https://developer.nvidia.com/embedded/jetson-linux-r3644

# Setup environment:
* Make the WorkDir:
```
mkdir jetson-linux-r3644 && cd  jetson-linux-r3644
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
* Download [Driver Package (BSP)](https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v4.4/release/Jetson_Linux_r36.4.4_aarch64.tbz2):
```
cd ${WORKDIR}
wget -P downloads https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v4.4/release/Jetson_Linux_r36.4.4_aarch64.tbz2
```
* Extract the BSP archive:
```
cd ${WORKDIR}
tar -xpf downloads/Jetson_Linux_r36.4.3_aarch64.tbz2 -C sources
export L4T_ROOT=${WORKDIR}/sources/Linux_for_Tegra
```
* Go to the source folder and download all sources:
```
cd ${WORKDIR}/sources/Linux_for_Tegra/source
export RELEASE_TAG=jetson_36.4.4
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
mkdir ${WORKDIR}/sources/Linux_for_Tegra/rootfs/{boot/dtbs,lib} -p
export INSTALL_MOD_PATH=${WORKDIR}/sources/Linux_for_Tegra/rootfs/
```

* Issue install into ``rootfs``:
```
export INSTALL_MOD_PATH=${WORKDIR}/sources/Linux_for_Tegra/rootfs/
sudo -E make install -C kernel
sudo -E make modules_install
sudo cp -a kernel-devicetree/generic-dts/dtbs/*-nv-super*.dtb ${INSTALL_MOD_PATH}/boot/dtbs/
sudo cp ${KERNEL_HEADERS}/arch/arm64/boot/Image ${INSTALL_MOD_PATH}/boot/
```

* Copy the device tree files to the ``${L4T_ROOT}/kernel/dtb``:
```
sudo cp -a kernel-devicetree/generic-dts/dtbs/* ${L4T_ROOT}/kernel/dtb/
```

# Rootfs mods
* (optional) Update the ``/boot/extlinux/extlinux.conf`` file:<br>
```
sudo sed -i "/^ *APPEND/i\      FDT /boot/dtbs/tegra234-p3768-0000+p3767-0005-nv-super-device.dtb" ${INSTALL_MOD_PATH}/boot/extlinux/extlinux.conf
```

# Flashing the device
  |Revision|Configuration ev|
  |---|---|
  |rev1v1|export EDGE_AI="edge-ai"|
  |rev1v2|export EDGE_AI="edge-ai-rev1v2"|

* The rootfs+bootlader
```
sudo ./tools/kernel_flash/l4t_initrd_flash.sh --external-device nvme0n1p1 \
  -c tools/kernel_flash/flash_l4t_t234_nvme.xml \
  -p "-c bootloader/generic/cfg/flash_t234_qspi.xml" \
  --showlogs --network usb0 ${EDGE_AI:-"edge-ai-rev1v2"} external | tee /tmp/edge-ai-rootfs-bootloader.log
```
* Bootloader
```
sudo ./tools/kernel_flash/l4t_initrd_flash.sh \
  -c tools/kernel_flash/flash_l4t_external.xml \
  -p "-c bootloader/generic/cfg/flash_t234_qspi.xml --no-systemimg" \
  --network usb0 ${EDGE_AI:-"edge-ai-rev1v2"} external | tee /tmp/edge-ai-bootloader.log
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

## CompuLab
* CompuLab development snapshot: https://github.com/compulab-yokneam/edge-ai-linux/blob/master/README.md
* Yet anover CompuLab resource: https://github.com/compulab-yokneam/compulab-l4t
* Yocto NVidia: https://github.com/OE4T/tegra-demo-distro
* Yocto CompuLab: https://github.com/compulab-yokneam/meta-tegra-compulab
