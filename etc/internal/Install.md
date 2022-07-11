# Install onto the internal media

* Make use the creatd usb media.
* Insert the media into a device USB port.
* Power on the device and wait for the grub menu:
```
                    GNU GRUB  version 2.06-3
┌───────────────────────────────────────────────────────────
│ Boot Linux RW
│ Boot Linux RO
│ Show Linux
│*Install Linux
| Advanced Boot Options
└───────────────────────────────────────────────────────────
```
* Issue Install Linux:
The installer will start running automatically:
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
```
* Follow the on-screen instructions.
