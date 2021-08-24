# System Ready Status

We have the working [environment](https://github.com/compulab-yokneam/compulab-sr) that allows creating a flash.bin image.

# Prepare iot-gate-imx8 for SR tests

## Prerequisites
* Connect a standard USB cable (included in the kit) between your host PC and the IOT-GATE-iMX8/SBC-IOT-iMX8 Debug console connector. [see drawing](https://mediawiki.compulab.com/w/index.php?title=File:Iot-gate-imx8_front-and-back-panels.png)
* Use a terminal emulator as described [here](https://mediawiki.compulab.com/w/index.php?title=IOT-GATE-iMX8:_Getting_Started#Quick_Setup)
* Power-on the system.
* Make sure that the device works and the U-Boot prompt turns out:
```
U-Boot SPL 2020.04-iot-gate-imx8-2.4 (May 30 2020 - 06:50:01 +0000)
power_bd71837_init
DDRINFO(D): Nanya 2048G
DDRINFO: start DRAM init
DDRINFO:ddrphy calibration done
DDRINFO: ddrmix config done
DDRINFO(M): mr5-8 [ 0x5000010 ]
DDRINFO(E): mr5-8 [ 0x5000010 ]
Normal Boot
Trying to boot from MMC2
NOTICE:  BL31: v2.2(release):imx_5.4.24_er3-dirty
NOTICE:  BL31: Built : 13:33:06, May 14 2020


U-Boot 2020.04-iot-gate-imx8-2.4 (May 30 2020 - 06:50:01 +0000)

CPU:   i.MX8MMQ rev1.0 at 1200 MHz
Reset cause: POR
Model: CompuLab IOT-GATE-iMX8
DRAM:  2 GiB
Suite:  MCM-iMX8M on unknown
MMC:   FSL_SDHC: 1, FSL_SDHC: 2
Loading Environment from MMC... *** Warning - bad CRC, using default environment

In:    serial
Out:   serial
Err:   serial

 BuildInfo:
  - ATF
  - U-Boot 2020.04-iot-gate-imx8-2.4

flash target is MMC:2
Net:   eth0: ethernet@30be0000
Fastboot: Normal
Normal Boot
Hit any key to stop autoboot:  0
IOT-GATE-iMX8 =>
```

## Update bootloader
* Download the usb image file [sr-update.img.xz](https://drive.google.com/file/d/1EWxyni0cHXBEL7EnqJEdIyTUD15B1E-t/view?usp=sharing).
* Flash the image file to a USB flash drive:
```bash
xz -dc /path/to/sr-update.img.zx | sudo dd of=/dev/sdX bs=1M
```
* Insert the USB flash drive into one of the USB ports.
* Power-on the system.
* The system will automatically boot the bootscript from the USB flash drive.
* At the end of the deployment process this message shows up:
```bash
Done: Remove USB stick & reset the device
```
* Done

## Create USB drive with ir_acs_live_image
* Download the usb image file [ir_acs_live_image.img.xz](https://drive.google.com/file/d/1a1zehlPGg4BNzVtsOAgkuE4--IhYP2Ub/view?usp=sharing).
* Flash the image file to a USB flash drive:
```bash
xz -dc /path/to/ir_acs_live_image.img.xz | sudo dd of=/dev/sdX bs=1M
```

# Run the SR tests
* Insert the USB flash drive into one of the USB ports.
* Power-on the system.
* The system will automatically start IR test procedure.
