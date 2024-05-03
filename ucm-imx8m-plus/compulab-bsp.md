# Configuring the build

* Prerequisites

| NAME | Value |
|---|---|
|NXP_BRANCH|imx-linux-mickledore|
|NXP_MANIFEST|imx-6.1.55-2.2.0.xml|
|COMPULAB_BRANCH|mickledore-2.2.0|
|COMPULAB_MANIFEST|meta-bsp-imx8mp.xml|

* Available ```COMPULAB_MACINE```

| Machine | Command Line |
|---|---|
|ucm-imx8m-plus|```export COMPULAB_MACHINE=ucm-imx8m-plus```|
|mcm-imx8m-plus|```export COMPULAB_MACHINE=mcm-imx8m-plus```|
|~~som-imx8m-plus~~|~~```export COMPULAB_MACHINE=som-imx8m-plus```~~|
|~~iot-gate-imx8plus~~|~~```export COMPULAB_MACHINE=iot-gate-imx8plus```~~|
|~~sbc-iot-imx8plus~~|~~```export COMPULAB_MACHINE=iot-gate-imx8plus```~~|

## Setup Yocto environment

* WorkDir:
```
mkdir compulab-nxp-bsp && cd compulab-nxp-bsp
```

* Set a CompuLab machine:
```
export MACHINE=${COMPULAB_MACHINE}
```

## Initialize repo manifests

* NXP
```
repo init -u https://github.com/nxp-imx/imx-manifest.git -b ${NXP_BRANCH} -m ${NXP_MANIFEST}
```

* CompuLab
```
mkdir -p .repo/local_manifests
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx8mp/${COMPULAB_BRANCH}/scripts/${COMPULAB_MANIFEST}
```

* Sync Them all
```
repo sync
```
## Setup build environment

* Initialize the build environment:
```
source compulab-setup-env -b build-${MACHINE}
```

## Build targets

* Building the image:
```
bitbake -k imx-image-full
```

* Building the bootloader file only:

| build command | binary file location |
|---|---|
|```bitbake -k imx-boot```|```${BUILDDIR}/tmp/deploy/images/${MACHINE}/imx-boot-tagged```|

## Building the build machine tools

* Building the UUU:

| build command | binary file location |
|---|---|
|```bitbake -k uuu-native```|```${BUILDDIR}/tmp/deploy/images/${MACHINE}/uuu-native/bin/uuu```|
 
* Install the UUU:<br>
```sudo ln -sf $(readlink -e ${BUILDDIR}/tmp/deploy/images/${MACHINE}/uuu-native/bin/uuu) /usr/local/bin```

## Get back to the already created build environment
```
cd compulab-nxp-bsp
repo sync
source setup-environment build-${MACHINE}
```

## Deployment
### Create a bootable sd card

* Goto the `tmp/deploy/images/${MACHINE}` directory:
```
cd tmp/deploy/images/${MACHINE}
```

* Flash the image onto the sd-card:
```
zstd -dc imx-image-full-${MACHINE}.wic.zst > imx-image-full-${MACHINE}.wic
sudo bmaptool copy --bmap imx-image-full-${MACHINE}.wic.bmap imx-image-full-${MACHINE}.wic /dev/sdX
```

### Deployment the image onto the device eMMC:
#### An interactive mode:
##### Grub Mode #####
* Insert the sd-card into the P23 slot.
* Turn on the device.
* Choose "Install NXP i.MX Release Distro ..." from the grub menu
##### Linux Mode #####
* Insert the sd-card into the P23 slot.
* Turn on the device.
* When in Linux issue:<br>```cl-deploy```
#### A non interactive mode:
* Insert the sd-card into the P23 slot.
* Turn on the device, stop in U-Boot and type:<br>```setenv root_opt ${root_opt} init=/usr/local/bin/cl-init; boot```
* The installer will start running automatically:
```
 Autoinstaller
 ------------------------------------------------------------------------------


          +--------cl-deploy will get started in 5 seconds-----------+
          | Configuration file /etc/cl-auto.conf parameters:         |
          | --------------------------------------------------       |
          | # Destination is the module inthernal media.             |
          | # Autoinstaller how to:                                  |
          | ## cp /usr/share/cl-deploy/cl-auto.conf.sample           |
          | /etc/cl-auto.conf                                        |
          | ## cl-auto -A                                            |
          | DST=/dev/mmcblk2                                         |
          | QUIET=Yes                                                |
          | --------------------------------------------------       |
          | Press any key for terminating ...                        |
          +----------------------------------------------------------+
          |                 <Stop Auto Installer>                    |
          +----------------------------------------------------------+




which: no systemctl in ((null))

    Clonning Block Device
    Started: /dev/mmcblk1 ==> /dev/mmcblk2

Checking that no-one is using this disk right now ... OK

Disk /dev/mmcblk2: 29.12 GiB, 31268536320 bytes, 61071360 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x94e280c2

Old situation:

Device         Boot  Start      End  Sectors  Size Id Type
/dev/mmcblk2p1 *     16384   186775   170392 83.2M  c W95 FAT32 (LBA)
/dev/mmcblk2p2      196608 12799115 12602508    6G 83 Linux

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x94e280c2.
/dev/mmcblk2p1: Created a new partition 1 of type 'W95 FAT32 (LBA)' and of size 83.2 MiB.
Partition #1 contains a vfat signature.
/dev/mmcblk2p2: Created a new partition 2 of type 'Linux' and of size 6 GiB.
Partition #2 contains a ext4 signature.
/dev/mmcblk2p3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x94e280c2

Device         Boot  Start      End  Sectors  Size Id Type
/dev/mmcblk2p1 *     16384   186775   170392 83.2M  c W95 FAT32 (LBA)
/dev/mmcblk2p2      196608 12799115 12602508    6G 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
Disk /dev/mmcblk2: 29.12 GiB, 31268536320 bytes, 61071360 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x94e280c2

Old situation:

Device         Boot  Start      End  Sectors  Size Id Type
/dev/mmcblk2p1 *     16384   186775   170392 83.2M  c W95 FAT32 (LBA)
/dev/mmcblk2p2      196608 12799115 12602508    6G 83 Linux

/dev/mmcblk2p2:
New situation:
Disklabel type: dos
Disk identifier: 0x94e280c2

Device         Boot  Start      End  Sectors  Size Id Type
/dev/mmcblk2p1 *     16384   186775   170392 83.2M  c W95 FAT32 (LBA)
/dev/mmcblk2p2      196608 61071359 60874752   29G 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
mkfs.fat 4.1 (2017-01-24)
[ /dev/mmcblk1p1 => /dev/mmcblk2p1 ]: 30.3MiB 0:00:00 [55.5MiB/s] [<=>         ]
mke2fs 1.45.6 (20-Mar-2020)
/dev/mmcblk2p2 contains a ext4 file system labelled 'root'
        last mounted on / on Thu Jan  1 00:00:03 1970
Discarding device blocks: done
Creating filesystem with 7609344 4k blocks and 1905008 inodes
Filesystem UUID: 13229d46-e15f-4406-9996-120046836dec
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

[ /dev/mmcblk1p2 => /dev/mmcblk2p2 ]: 3.41GiB 0:01:36 [36.1MiB/s] [<=>         ]

    Done: /dev/mmcblk1 ==> /dev/mmcblk2

Sample /usr/share/cl-deploy/app/00_cl-deploy.app script
         #####  #     #  #####   #####  #######  #####   #####
        #     # #     # #     # #     # #       #     # #     #
        #       #     # #       #       #       #       #
         #####  #     # #       #       #####    #####   #####
              # #     # #       #       #             #       #
        #     # #     # #     # #     # #       #     # #     #
         #####   #####   #####   #####  #######  #####   #####
        Autoinstall mode has been disabled successfully.
        Init: /tmp/tmp.Fq418wPIJ8//sbin/init: symbolic link to ../lib/systemd/systemd
        Rebooting in 3 seconds...
```

# Using UUU

Prerquirements:
* Connect the device to a Linux desktop using a TypeC (USB1) port.
* On the Linux machine open up a terminal window and type:<br>```udevadm monitor```
* Turn on the device, stop in U-Boot and issue:<br>```fastboot 0```
* The Linux machine teminal must show this up:<pre>
monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent
KERNEL[29006471.097823] add      /devices/pci0000:00/0000:00:14.0/usb1/1-8 (usb)
KERNEL[29006471.098557] add      /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0 (usb)
UDEV  [29006471.108663] add      /devices/pci0000:00/0000:00:14.0/usb1/1-8 (usb)
UDEV  [29006471.111241] add      /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0 (usb)

Goto ${DEPLOYDIR} first:
```
cd ${BUILDDIR}/tmp/deploy/images/${MACHINE}
```

## Burn bootloader into emmc
```
sudo uuu -d -v -b emmc imx-boot-tagged
```

## Burn rootfs image into emmc
```bash
zstd -dc imx-image-full-${MACHINE}.wic.zst > imx-image-full-${MACHINE}.wic
sudo uuu -d -v -b emmc_all imx-boot-tagged mx-image-full-${MACHINE}.wic
```

# SDP
The device gets into this mode if the default boot device does not have a valid bootloader.

## Boot the device using the SDP
The simpest way to make the device get into this mode is to issue AltBoot w/out sd-card in the P23 slot.<br>
How to proceed:
* Turn on the device, stop in U-Boot.
* On the Linux development machine open up a terminal window and type:<br>```udevadm monitor```
* On the target device:
  * One time AltBoot mode
    * press and hold `ALT_BOOT`
    * toggle `RESET`
    * release `ALT_BOOT`
  * Permanet AltBoot mode for development purpose only.<br>
    Set the E17 jumper on.<br>
    * toggle `RESET`

* The Linux machine teminal must show this up:<pre>
udevadm monitor 
monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent
KERNEL[29005568.006052] add      /devices/pci0000:00/0000:00:14.0/usb1/1-8 (usb)
KERNEL[29005568.006786] add      /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0 (usb)
KERNEL[29005568.007427] add      /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/0003:1FC9:0146.158A (hid)
KERNEL[29005568.007887] add      /class/usbmisc (class)
KERNEL[29005568.007967] add      /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/usbmisc/hiddev0 (usbmisc)
KERNEL[29005568.008199] add      /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/0003:1FC9:0146.158A/hidraw/hidraw0 (hidraw)
UDEV  [29005568.010271] add      /class/usbmisc (class)
UDEV  [29005568.016915] add      /devices/pci0000:00/0000:00:14.0/usb1/1-8 (usb)
UDEV  [29005568.019897] add      /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0 (usb)
UDEV  [29005568.022544] add      /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/usbmisc/hiddev0 (usbmisc)
UDEV  [29005568.022577] add      /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/0003:1FC9:0146.158A (hid)
UDEV  [29005568.023299] add      /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/0003:1FC9:0146.158A/hidraw/hidraw0 (hidraw)
</pre>

* Make sure that the connected device is in the SDP mode:<pre>
uuu -lsusb
uuu (Universal Update Utility) for nxp imx chips -- libuuu_1.5.11-0-g7c0fb61
Connected Known USB Devices
        Path     Chip    Pro     Vid     Pid     BcdVersion
        ==================================================
        1:1      MX865   SDPS:   0x1FC9 0x0146   0x0002
</pre>

| NOTE | When the device in SDP mode, the device serial console is irresponsive |
|---|---|

* Download the bootloader
  * Issue this command from the Linux development host<pre>sudo uuu -d -v imx-boot-tagged</pre>
  * The target device serial console sample output:<pre>
U-Boot SPL 2023.04-compulab+gb31d600948 (Feb 01 2024 - 11:53:52 +0000)
pca9450@25 [ldo4][u] = 1v8
DDRINFO: EEPROM VALID DATA [ [ cafecafe ] = ffffffff ff 
DDRINFO: Cfg attempt: [ 1/6 ]
DDRINFO(?): deadbeaf 2048MB @ 3000 MHz
DDRINFO: start DRAM init
DDRINFO: DRAM rate 3000MTS
DDRINFO:ddrphy calibration done
DDRINFO: ddrmix config done
DDRINFO(M): mr5-8 [ 0x1061010 ]
DDRINFO(T): mr5-8 [ 0xdeadbeef ]
spl_dram_ů
U-Boot SPL 2023.04-compulab+gb31d600948 (Feb 01 2024 - 11:53:52 +0000)
pca9450@25 [ldo4][u] = 1v8
DDRINFO: Cfg attempt: [ 2/6 ]
DDRINFO(?): Samsung 4096MB @ 3200 MHz
DDRINFO: start DRAM init
DDRINFO: DRAM rate 3200MTS
DDRINFO:ddrphy calibration done
DDRINFO: ddrmix config done
DDRINFO(M): mr5-8 [ 0x1061010 ]
DDRINFO(T): mr5-8 [ 0x1061010 ]
DDRINFO(E): mr5-8 [ 0x1061010 ], read back
DDRINFO(EEPROM): make sure that the eeprom is accessible
DDRINFO(EEPROM): i2c dev 1; i2c md 0x51 0x40 0x50
spl_dram_é
U-Boot SPL 2023.04-compulab+gb31d600948 (Feb 01 2024 - 11:53:52 +0000)
pca9450@25 [ldo4][u] = 1v8
DDRINFO: EEPROM VALID DATA [ [ cafecafe ] = 1061010 4 
DDRINFO(D): Samsung 4096MB @ 3200 MHz
DDRINFO: start DRAM init
DDRINFO: DRAM rate 3200MTS
DDRINFO:ddrphy calibration done
DDRINFO: ddrmix config done
DDRINFO(M): mr5-8 [ 0x1061010 ]
DDRINFO(E): mr5-8 [ 0x1061010 ]
SEC0:  RNG instantiated
Normal Boot
Trying to boot from BOOTROM
Boot Stage: USB boot
Find img info 0x480163a0, size 1064
Need continue download 1024
Download 1859632, Total size 1860752
NOTICE:  Do not release JR0 to NS as it can be used by HAB
NOTICE:  BL31: v2.8(release):lf-6.1.55-2.2.0-0-g08e9d4eef
NOTICE:  BL31: Built : 06:43:30, Nov 21 2023
\
U-Boot 2023.04-compulab+gb31d600948 (Feb 01 2024 - 11:53:52 +0000)
\
CPU:   i.MX8MP[8] rev1.1 1800 MHz (running at 1200 MHz)
CPU:   Commercial temperature grade (0C to 95C) at 54C
Reset cause: POR
Model: CompuLab UCM-iMX8M-Plus
DRAM:  4 GiB
Core:  247 devices, 37 uclasses, devicetree: separate
MMC:   FSL_SDHC: 1, FSL_SDHC: 2
Loading Environment from nowhere... OK
[*]-Video Link 1Enable clock-controller@30380000 failed
Enable clock-controller@30380000 failed
 (1024 x 600)
	[0] lcd-controller@32e90000, video
	[1] lvds-channel@0, display
	[2] lvds-panel, panel
In:    serial
Out:   vidconsole
Err:   vidconsole
SEC0:  RNG instantiated
MMC Device 0 not found
no mmc device at slot 0
Detect USB boot. Will enter fastboot mode!
Net:   eth1: ethernet@30bf0000 [PRIME]
Fastboot: Normal
Boot from USB for mfgtools
*** Warning - Use default environment for 				 mfgtools
, using default environment
\
Run bootcmd_mfg: run mfgtool_args;if iminfo ${initrd_addr}; then if test ${tee} = yes; then bootm ${tee_addr} ${initrd_addr} ${fdt_addr}; else booti ${loadaddr} ${initrd_addr} ${fdt_addr}; fi; else echo "Run fastboot ..."; fastboot 0; fi;
Hit any key to stop autoboot:  0 
\
\#\# Checking Image at 43800000 ...
Unknown image format!
Run fastboot ...
</pre>
