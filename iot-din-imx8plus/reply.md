Dear Customer,

Thanks for providing the info;
The log shows that a Kingston 2G DRAM id [ 0xff070010 ] is in use.

Please have a look at this string:
https://github.com/compulab-yokneam/u-boot-compulab/blob/86b924310f84d7a026ccb6101734385cc917959f/board/compulab/plat/imx8mp/ddr/ddr.h#L131

This is the U-Boot dram array used by BalenaOS for the default iot-din d2d4 setup; and this DRAM is in supported dram's list.

I'd appreciate it if you could issue this procedure and post the console log:
1) Download the imx-boot file from this location:
https://drive.google.com/drive/folders/13_sbUnRH9Ja7-crbSNh8K97hVLZPfTUi

2)  Use this procedure, but with the file from gdrive:
https://mediawiki.compulab.com/w/index.php?title=IOT-DIN-IMX8PLUS:_U-Boot:_Recovery

The gdrive file is the BalenaOS bootloader with the enabled console output.

Regards,
Valentin.
