# Production Deployment imx8mp

* Follow the instructions of this page:
[Production Deployment](https://mediawiki.compulab.com/w/index.php?title=IOT-GATE-iMX8_and_SBC-IOT-iMX8:_Linux:_Production_Deployment)

* Before power off issue these commands:
```
fw_setenv console 'ttymxc1,115200'
fw_setenv bootcmd 'run bsp_bootcmd'
```
