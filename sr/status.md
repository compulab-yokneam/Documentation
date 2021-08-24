# System Ready Status

We have the working [environment](https://github.com/compulab-yokneam/compulab-sr) that allows creating a flash.bin image.

# Prepare iot-gate-imx8 for SR tests

## Update bootloader
* Download the usb image file [sr-update.img.xz](https://drive.google.com/file/d/1EWxyni0cHXBEL7EnqJEdIyTUD15B1E-t/view?usp=sharing).
* Flash the image file to a USB flash drive:
```bash
xz -dc /path/to/sr-update.img.zx | sudo dd of=/dev/sdX bs=1M
```
* Insert the USB flash drive into one of the USB ports.
* Connect a standard USB cable (included in the kit) between your host PC and the IOT-GATE-iMX8/SBC-IOT-iMX8 Debug console connector. [see drawing](https://mediawiki.compulab.com/w/index.php?title=File:Iot-gate-imx8_front-and-back-panels.png)
* Use a terminal emulator as described [here](https://mediawiki.compulab.com/w/index.php?title=IOT-GATE-iMX8:_Getting_Started#Quick_Setup)
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
