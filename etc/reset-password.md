# How to re/set password on CompuLab imx8mp devices

## Prerequisites
* An imx8mp device
* Serial connection to a Desktop PC

## Procedure
* Turn on the imx8mp device and stop in U-boot.
* Type:
```
setenv boot_opt "init=/usr/local/bin/cl-init"; setenv console "ttymxc1,115200"; run bsp_bootcmd;
```
## This screen shows up; press ``Stop Auto Installer``
```

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
 | UDEV=No                                                  |  
 | --------------------------------------------------       |  
 +-----------------------------------------------------91%--+  
 |                 <Stop Auto Installer>                    |  
 +----------------------------------------------------------+  
```

## Next screen shows up; it has a long PS1 prompt with a ">" at the end
```
  on/E -- Enable auto install boot mode
 off/D -- Disable auto install boot mode
     M -- Modify /etc/cl-auto.conf file
     C -- Copy /usr/share/cl-deploy/cl-auto.conf.sample file to /etc/cl-auto.conf
     G -- Start autoinstaller now
     U -- Toggle dry run
     X -- Exit cl-auto.shell
     B -- Fast reboot
     O -- Poweroff


Conf file:
# Destination is the module inthernal media.
# Autoinstaller how to:
## cp /usr/share/cl-deploy/cl-auto.conf.sample /etc/cl-auto.conf
## cl-auto -A
DST=/dev/mmcblk2
QUIET=Yes
UDEV=No

autoinstaller ( device: /dev/mmcblk2 ;  boot mode : off ; dry run : no) >
```

## Password set procedure:
* Issue ``passwd compulab`` command:
```
autoinstaller ( device: /dev/mmcblk2 ;  boot mode : off ; dry run : no) > passwd compulab
New password:
Retype new password:
passwd: password updated successfully
...
autoinstaller ( device: /dev/mmcblk2 ;  boot mode : off ; dry run : no) >
```
* Reboot the device: Type ``B+<Enter>``
```
autoinstaller ( device: /dev/mmcblk2 ;  boot mode : off ; dry run : no) > B
```
