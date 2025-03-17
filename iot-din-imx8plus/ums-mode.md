# ums mode to update internal emmc

1) Turn on the devive and stop in U-boot.

2) Connect an USB to micrco_usb cable to the device programming port (on bottom panel) and to the Linux PC usb port.

``` 
iot-din:mng-port <-> micro_sd -- usb_a <-> Linux PC:usb-port
```

3) Issue this command in U-Boot:
```
ums 0 mmc 2
```

4) On the connected Linux PC, make sure that the device got recognized as an usb mass storage device.

5) Follow this [manual](https://mediawiki.compulab.com/w/index.php?title=IOT-DIN-IMX8PLUS:_Debian_Linux:_Preparing_Live_Media)

|NOTE|/dev/sdX must be a block device created after issuing the "ums" command in the device U-boot|
|---|---|

For instance the created device was named as `/dev/sdg`, then the command must be:

```
unzip -p /path/to/iot-din-imx8plus_debian-linux_2023-10-11.zip | sudo dd of=/dev/sdg bs=1M status=progress conv=fsync
```

6) At the end of the process on the Linux PC issue this command:
```
lsblk /dev/sdg
```

  * Make sure that it has two partitions.

  * Issue these command and make sure that were carried out w/out any error.
```
udisksctl mount --block-device /dev/sdg1
```
Browse the /dev/sdg1 device mount point; make sure that it contains the Linux kernel image and the device tree files.
```
udisksctl mount --block-device /dev/sdg2
```

Browse the /dev/sdg2 device mount point; it must the the Debia rootfs; issue this command:
```
cat /path/to/rootfs/etc/{issue,hostname}
```

  * Unmount both devices:

```
udisksctl unmount --block-device /dev/sdg1
udisksctl unmount --block-device /dev/sdg2
```

7) Go back to the iot-din managment console and stop "ums" command: Crtl+C

8) Disconnect usb-cable from the device programming port.

9) Reset the device.

10) Make sure that the device is able to boot at and run the install OS.
