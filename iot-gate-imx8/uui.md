# U-Boot update procedure

## Download the U-boot update image
* [U-Boot Update Image](https://drive.google.com/drive/folders/1deziCeCNTcAx6ajkbX0tpAghaKOQAFFG)

## Create a u-boot update usb media
```                                          
xz -dc /path/to/uui.image.xz | sudo dd of=/dev/sdX bs=1M conv=fsync
```

## Turn on the device, stop in U-boot.
## Insert the usb media into the front usb port.
## Issue:
```                                                                       
gpio set 124; setenv script update.scr; boot
```
## Done
