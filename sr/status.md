# System Ready Status

We have a working [environment](https://github.com/compulab-yokneam/compulab-sr) that allows creating a flash.bin image.

# iot-gate-imx8 to ARM validation device
* Download the usb image from this [location](https://drive.google.com/drive/folders/1RrKbNv6OClDobwBLrIkFKKeLYpl9TOin).
* Flash the image file to a USB flash drive:
```bash
xz -dc usb_sr.img.xz | sudo dd of=/dev/sdX bs=1M
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
