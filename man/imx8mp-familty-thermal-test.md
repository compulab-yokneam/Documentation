# iMX8 Plus

## Prepare the device for thermal testing:

* Update the bootcmd:
```
fw_setenv bootcmd 'run bsp_bootcmd'
```

* Set up the fdtofile:
```
fw_setenv fdtofile compulab-imx8m-plus-thermal.dtbo
```

* Use a headless device tree if possible:
```
eval $(fw_printenv fdtfile)
fdtfile_headless=${fdtfile/.dtb/-headless.dtb}
ls /boot | grep -q $fdtfile_headless && fw_setenv fdtfile ${fdtfile_headless} || true
```
