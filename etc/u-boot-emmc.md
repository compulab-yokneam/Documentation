# How to

## Emmc hw partition information:

* U-boot:

|command|output|
|---|---|
|mmc list|FSL_SDHC: 0 (eMMC)<br>FSL_SDHC: 1 (SD)|
|mmc dev 0|switch to partitions #0, OK<br>mmc0(part 0) is current device|
|mmc info|Device: FSL_SDHC<br>Manufacturer ID: 70>br>OEM: 100<br>Name: TB291<br>Bus Speed: 52000000<br>Mode: MMC High Speed (52MHz)<br>Rd Block Len: 512<br>MMC version 5.1<br>High Capacity: Yes<br>Capacity: 14.6 GiB<br>Bus Width: 8-bit<br>Erase Group Size: 512 KiB<br>HC WP Group Size: 8 MiB<br>User Capacity: 14.6 GiB<br>**Boot Capacity: 4 MiB ENH**<br>RPMB Capacity: 4 MiB ENH|

* Linux:

|command|output|
|---|---|
|lsblk|<br>mmcblk0      179:32   0 14.6G  0 disk<br>\|-mmcblk0p1  179:33   0 83.2M  0 part /run/media/mmcblk0p1<br>\`-mmcblk0p2  179:34   0 14.5G  0 part /<br>**mmcblk0boot0 179:64   0    4M  1 disk**<br>mmcblk0boot1 179:96   0    4M  1 disk

## Switch between partitions:

|partititon|environment|command|
|---|---|---|
|user partition|u-boot|mmc partconf 0 0 0 0|
||linux|mmc bootpart enable 0 0 /dev/mmcblk0|
|boot partition|u-boot|mmc partconf 0 0 1 0|
||linux|mmc bootpart enable 1 0 /dev/mmcblk0|

## Flash the u-boot

* user partition:
```
echo 0 > /sys/class/block/mmcblk0/force_ro
dd if=/boot/imx-boot-cl-som-imx8-sd.bin-flash_evk of=/dev/mmcblk0 bs=1K seek=33
mmc bootpart enable 0 0 /dev/mmcblk0
```

* boot partition:
```
echo 0 > /sys/class/block/mmcblk0boot0/force_ro
dd if=/boot/imx-boot-cl-som-imx8-sd.bin-flash_evk of=/dev/mmcblk0boot0 bs=1K seek=33
mmc bootpart enable 1 0 /dev/mmcblk0
```
