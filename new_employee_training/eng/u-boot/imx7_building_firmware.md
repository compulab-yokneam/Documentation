1. [Setup host](../host_configuration.md)
2. [Get sources](imx7_getting_sources.md)
3. Build images
```
cd /path/to/u-boot-cl-som-imx7/
export ARCH=arm
export CROSS_COMPILE=/path/to/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
make mrproper
make cl-som-imx7_defconfig && make
```
4. Prepare a final firmware image
```
dd if=/dev/zero count=640 bs=1K | tr '\000' '\377' > cl-som-imx7-firmware
dd if=SPL of=cl-som-imx7-firmware bs=1K seek=1 conv=notrunc
dd if=u-boot.img of=cl-som-imx7-firmware bs=1K seek=64 conv=notrunc
```
