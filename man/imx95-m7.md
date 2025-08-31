# imx95 m7 how to

## Prerequisites:

|Module| ... |
|---|---|
|imx-system-manager|config: mx95cplrpmsg|
|imx-boot|target: lpboot_sm_a55|
|fdtfile|ucm-imx95-rpmsg.dtb|

## How to proceed
### Load and run the m7 core from u-boot

* Turn on the device and stop in U-Boot and issue:
```
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
echo -n "imx95-15x15-evk_m7_TCM_rpmsg_lite_str_echo_rtos.elf" > /sys/class/remoteproc/remoteproc1/firmware
echo start >  /sys/class/remoteproc/remoteproc1/state
modprobe imx_rpmsg_tty
[[ -c /dev/ttyRPMSG30 ]] && echo "ping from linux" > /dev/ttyRPMSG30 || echo "Something goes wrong"
```
