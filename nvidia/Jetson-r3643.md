# Start from here
https://developer.nvidia.com/embedded/jetson-linux-r3643

# Environmnet
```
export ARCH=arm64
export CROSS_COMPILE=/opt/aarch64--glibc--stable-2022.08-1/bin/aarch64-buildroot-linux-gnu-
```

# Build

* Goto to the source root and set an ev `KERNEL_HEADERS`
```
cd /path/to/jetson-linux-r3643/Linux_for_Tegra/source
export KERNEL_HEADERS=$PWD/kernel/kernel-jammy-src
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
mkdir /path/to/jetson-linux-r3643/Linux_for_Tegra/rootfs/{boot,lib} -p
export INSTALL_MOD_PATH=/path/to/jetson-linux-r3643/Linux_for_Tegra/rootfs/
```

* Issue install
```
export INSTALL_MOD_PATH=/path/to/jetson-linux-r3643/Linux_for_Tegra/rootfs/
sudo -E make install -C kernel
sudo -E make modules_install
sudo cp -a kernel-devicetree/generic-dts/dtbs ${INSTALL_MOD_PATH}/boot/
```
