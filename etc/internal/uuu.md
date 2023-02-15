# Deploy the image and the bootloader using UUU

* Get the NXP MFGTools uisn onr of the methods:

| Method #| Description |
|:--- | :--- |
|[Debian snapcraft](https://snapcraft.io/install/universal-update-utility/debian) | OS Distro/Easy |
|[NXP UUU](https://github.com/nxp-imx/mfgtools)| NXP Source/Medium |


# For non-bricked devices:

|Device|SDP/FB-port|
|:---|:---|
|ucm-imx8plus|J5|
|cl-som-imx8plus|J5|

## On the device:
* Turn off the device.
* Connect the device to a Linux host PC using a USB Type-C to USB-A Male cable
* Turn on the device and stop in U-Boot; issue:```fastboot 0```

## On the Linux host:
* Flash the tootloader onto the emmc:
```
sudo /path/to/uuu -v -b emmc /path/to/imx-boot-${MACHINE}-sd.bin-flash_evk
```

* Flash the bootloader and the OS image onto the emmc:
```
sudo /path/to/uuu -v -b emmc_all /path/to/imx-boot-${MACHINE}-sd.bin-flash_evk /path/to/imx-image-multimedia-${MACHINE}-${TIMESTAMP}.rootfs.wic.bz2
```
The process takes some time depends on the image size. Issue ```reset``` at the end of the process.
