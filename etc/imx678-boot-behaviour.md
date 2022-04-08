# CompuLab iMX SoM boot behaviour

## imx6,7

|Boot Method|U-Boot location|U-Boot Environment Behaviour|
|----|----|----|
|Normal Boot|SPI-Flash 0x400 offset|Default U-Boot environment bootcmd tries all available boot candidates: sd/usb/emmc/nand|
|AltBoot|SD-card 0x400 offset|The same as normal boot.|

# imx8
This chapter mentions the eMMC hardware partitions. Details at: https://www.jedec.org/sites/default/files/Victo_Tsai(1).pdf
* imx8mq/imx8mm

|Boot Method|U-Boot location|U-Boot Environment Behaviour|
|----|----|----|
|Normal Boot|eMMC.user/boot0/boot1 0x33K offset|Default U-Boot environment bootcmd tries all available boot candidates: sd/usb/emmc|
|AltBoot|SD-card 0x33K offset|The same as normal boot.|

* imx8mp

|Boot Method|U-Boot location|U-Boot Environment Behaviour|
|----|----|----|
|Normal Boot|eMMC.user 0x32K offset<br>eMMC.boot0/1 0K offset<br>|Default U-Boot environment bootcmd tries all available boot candidates: sd/usb/emmc|
|AltBoot|SD-card 0x32K offset|The same as normal boot.|
