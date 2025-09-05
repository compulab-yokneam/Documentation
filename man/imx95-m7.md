# imx95 m7 how to

## Introduction
NXP imx-system-manager has two configurations that provide different permissions two each core.

* ``mx95cp`` permission matrix

|*|M33|M7|A55
|---|---|---|---|
|M33|---|full|full|
|M7|---|---|suspemd/resume;rpmsg|
|A55|---|rpmsg|---|

* ``mx95cprpmsg`` permission matrix
 
|*|M33|M7|A55
|---|---|---|---|
|M33|---|full|full|
|M7|---|---|suspemd/resume;rpmsg|
|A55|---|full|---|


## Prerequisites

* SW
  
|Module| ... |
|---|---|
|imx-system-manager|config: mx95cplrpmsg|
|imx-boot|target: all (m33 loads/boots/starts m7); lpboot_sm_a55|
|fdtfile|ucm-imx95.dtb|

* HW

|Module| ... |
|---|---|
|EVK|ucm-imx95 on SB-UCMIMX95|
|M33-Console|UARTB: P19[2(rx),4(tx),6(gnd)]
|M7-Console|UARTA: P20[2(rx),4(tx),6(gnd)]

## How to proceed
### Load and run the m7 core from u-boot

* Turn on the device and stop in U-Boot and issue:
```
stopaux 0 1
prepaux 1
load mmc 0:2 ${loadaddr} lib/firmware/imx95-19x19-evk_m7_TCM_power_mode_switch.bin
cp.b ${loadaddr} 0x203c0000 ${filesize}
bootaux 0 1
```

### Load and run the m7 core from Linux
* Turn on the device and stop in U-Boot and issue:
```
prepaux 1
setenv  boot_opt 'clk_ignore_unused pd_ignore_unused clk-imx95.mcore_booted'
seten fdtfile ucm-imx95-rpmsg.dtb
saveenv
boot
```
* Linux login prompt turns out, login as ``root`` and issue:
```
echo stop > /sys/class/remoteproc/remoteproc1/state
echo -n "imx95-15x15-evk_m7_TCM_rpmsg_lite_str_echo_rtos.elf" > /sys/class/remoteproc/remoteproc1/firmware
echo start > /sys/class/remoteproc/remoteproc1/state
modprobe imx_rpmsg_tty
[[ -c /dev/ttyRPMSG30 ]] && echo "ping from linux" > /dev/ttyRPMSG30 || echo "Something goes wrong"
```
