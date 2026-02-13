# Mender how to

## How to get a Mender image:
* Long Way<br>
  Follow the instructions of [this manual](https://github.com/compulab-yokneam/meta-mender-compulab) and create a Yocto Mender image.
* Short Way<br>
  Download a ready to run Mender Image from [this location](https://drive.google.com/drive/folders/1L8VgVIp146HEkAk7j6o3_wdKVP1jo8s6).
## How to deploy
* UUU Method
  * Linux Desktop
    ```
    sudo uuu -bmap -v -b emmc_all  imx-boot.tagged fsl-image-network-full-cmdline-iotdin-imx8p-20260210205430.sdimg
    ```
  * Targer Device
   
    |NOTE|The target device must be in SDP 'or' in fastboot 0 mode|
    |:---|:---|
    
## Target device first steps:
* Reset the device, stop in U-Boot and issue:
  ```
  env default -a; saveenv; reset
  ```
* Let the device get to the Linux prompt and issue:
  *  List information about block devices:
      ```
      lsblk
      NAME         MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
      mmcblk2      179:0    0 14.6G  0 disk
      |-mmcblk2p1  179:1    0   64M  0 part /boot/efi
      |-mmcblk2p2  179:2    0  1.9G  0 part /
      |-mmcblk2p3  179:3    0  1.9G  0 part
      `-mmcblk2p4  179:4    0 10.7G  0 part /data
      mmcblk2boot0 179:32   0    4M  1 disk
      mmcblk2boot1 179:64   0    4M  1 disk
      ```
  * Dump the kernel bootargs:
      ```
      cat /proc/cmdline
      BOOT_IMAGE=/boot/Image root=PARTUUID=09501fb1-02 console=ttymxc1,115200n8 rootwait
      ```
  * Print the Mender environment:
      ```
      grub-mender-grubenv-print
      bootcount=0
      mender_boot_part=2
      upgrade_available=0
      ```
  * Switch to another Mender rootfs partition:
      ```
      grub-mender-grubenv-set mender_boot_part 3
      ```
  * Reboot the device, make sure that the root device is ``/dev/mmcblk2p3``:
    ```
    findmnt / -n -o SOURCE
    ```
