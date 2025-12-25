# cm-t43 linux how to

## Build Machine:
```
mkdir /path/to/cm-t43-bsp && cd /path/to/cm-t43-bsp
export CROSS_COMPILE=/opt/gcc-15.2.0-nolibc/arm-linux-gnueabi/bin/arm-linux-gnueabi-
export ARCH=arm
git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git 
cd linux
git checkout -b cm-t43-dev-6.12 v6.12
make omap2plus_defconfig
make && make targz-pkg
```

## cm-t43 linux:
```
tar --keep-directory-symlink --directory=/ -xf /path/to/linux-6.12.0-arm.tar.gz
reboot
```

## cm-t43 u-boot:
```
load mmc 1:2 ${loadaddr} boot/vmlinuz-6.12.0
load mmc 1:2 ${fdtaddr} boot/dtbs/6.12.0/am437x-sbc-t43.dtb
setenv emmcroot "/dev/mmcblk1p2 rw"
run emmcargs
bootz ${loadaddr} - ${fdtaddr}
```
