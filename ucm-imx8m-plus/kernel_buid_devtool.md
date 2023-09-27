# Modifying the CompuLab Linux Kernel using devtool

## Go to the Yocto build environment:
```
cd ${BUILDDIR}
```

## Create the linux kernel tree snapshot:
```
devtool modify linux-compulab
```

## Go to the linux kernel source tree and modify it if required:
```
cd ${BUILDDIR}/workspace/sources/linux-compulab
```

## Build the linux kernel from the modified snapshot:
```
devtool build linux-compulab
```

Make sure that the command returns no compilation error.

## Issue the entire image build with the modified kernel:
```
bitbake -k imx-image-full
```

## Update the device with already created Yocto image:
* On the build machine:
```
tar -C ${BUILDDIR}/tmp/deploy/images/${MACHINE} -chvf /path/to/kerne-image.tar.bz2 Image modules-${MACHINE}.tgz
```

* On the device:
1) rootfs
```
tar -xOf /path/to/kerne-image.tar.bz2 modules-${MACHINE}.tgz | tar -C /lib/modules -xzvf -
tar -xOf /path/to/kerne-image.tar.bz2 Image | tee >/dev/null /boot/Image-mod
```
2) boot partition
```
mount /dev/mmcblk2p1 /boot/
mv /boot/Image /boot/Image-old
tar -xOf /path/to/kerne-image.tar.bz2 Image | tee >/dev/null /boot/Image
```

|!NOTE!|Don’t try modifying kernel source at ${BUILDDIR}/tmp/work/${MACHINE}-poky-linux/linux-compulab/${VERSION}|
|---|---|
