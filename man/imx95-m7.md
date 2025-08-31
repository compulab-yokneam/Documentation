# imx95 m7 how to

## Prerequisites:

|Module| ... |
|---|---|
|imx-system-manager|config: mx95cplrpmsg|
|imx-boot|target: lpboot_sm_a55|
|fdtfile|ucm-imx95-rpmsg.dtb

## How to proceed
* Turn on the device and stop in U-Boot and issue:
```
prepaux 1
load mmc 0:2 ${loadaddr} lib/firmware/imx95-15x15-evk_m7_TCM_power_mode_switch.bin
cp.b ${loadaddr} 0x203c0000 ${filesize}
bootaux 0 1
```
