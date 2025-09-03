# imx95 how to

## Yocto m7 rpmsg

* Set the **mx95cprpmsg** sm configuration:

```
cd ${BUILDDIR}
cat << eof | tee -a conf/local.conf
IMXBOOT_VARIANT = "rpmsg"
eof
```

* Set an m7 firmware that will be a part of the flash image:

```
cat << eof | tee -a conf/local.conf
M4_DEFAULT_IMAGE_MX95:mx95-generic-bsp = "imx95-19x19-evk_m7_TCM_rpmsg_lite_str_echo_rtos.bin"
eof
```

* Issue the bootloader build only:
```
bitbake -k imx-boot
```

* Result is in ``${BUILDDIR}/tmp/deploy/images/${COMPULAB_MACHINE}/imx-boot-tools:``
```
cd ${BUILDDIR}/tmp/deploy/images/${COMPULAB_MACHINE}/
ls -ltr | grep flash_all
```

## Post build customization:

* Recreate a flash file with anothe m7 firmware:
```
cd ${BUILDDIR}/tmp/deploy/images/${COMPULAB_MACHINE}/imx-boot-tools
./m7-set.sh
1) ../mcore-demos/imx95-19x19-evk_m7_TCM_flexcan_linux.bin
3) ../mcore-demos/imx95-19x19-evk_m7_TCM_netc_share.bin
5) ../mcore-demos/imx95-19x19-evk_m7_TCM_rpmsg_lite_pingpong_rtos_linux_remote.bin
7) ../mcore-demos/imx95-19x19-evk_m7_TCM_sai_low_power_audio.bin
2) ../mcore-demos/imx95-19x19-evk_m7_TCM_low_power_wakeword.bin
4) ../mcore-demos/imx95-19x19-evk_m7_TCM_power_mode_switch.bin
6) ../mcore-demos/imx95-19x19-evk_m7_TCM_rpmsg_lite_str_echo_rtos.bin
8) <<
m7 image: your choice > 4
make SOC=iMX95 REV=A0 OEI=YES LPDDR_TYPE=lpddr5 flash_all
ls -ltr | grep flash
```
