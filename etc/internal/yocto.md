# Yocto UUU & SDP

| Prerequisites | The entire Yocto image build procedure must be carried out first.
| :--- | :--- |


|Supported BSP|
| :--- |
|[honister](https://github.com/compulab-yokneam/meta-bsp-imx8mp/tree/honister)|
|[kirkstone](https://github.com/compulab-yokneam/meta-bsp-imx8mp/tree/kirkstone)|


## Build UUU in the Yocto build environment

* Get back to the Yocto build environment:
```
source setup <build-imx-platform>
```
* Issue UUU build:
```
bitbak uuu-native
```
As soon as the uuu-native process gets terminated w/out an error, go to the ${MACHINE} deployment folder:
```
cd ${BUILDDIR}/tmp/deploy/images/${MACHINE}
```

## SDP boot

This command make the device load the bootloader only:
```
sudo ./uuu-native/bin/uuu -v ./imx-boot
```

* Flash the tootloader onto the emmc:
```
sudo ./uuu-native/bin/uuu -v -b emmc ./imx-boot
```

* Flash the bootloader and the OS image onto the emmc:
```
sudo ./uuu-native/bin/uuu -v -b emmc_all ./imx-boot ./${TARGET-IMAGE}-${MACHINE}.wic.bz2
```

* Permanent SDP boot
 <br>1. Remove sd-card
 <br>2. Set the ALT_BOOT jumper (E19) on
