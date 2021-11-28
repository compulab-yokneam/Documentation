# Debian Installation Media

## Installation media.
* Please choose an installation media: 

| Supported installation devices | sd-card, usb-stick |
| :--- | :--- |

* Download the [Debian Installer Image](https://drive.google.com/file/d/1PmHPMfB8vWXEY0mK4lxPLbgxGbJJ-P7w/view?usp=sharing)

* Create an instalation media:
```
xz -dc /path/to/debian-bullseye-armhf-buildd-20211128105400.sdcard.img.xz | sudo dd of=/dev/sdX bs=1M statusp=progress
```
Make use of the created media for booting the device.

## Installation procedure.
* Turn on the device, stop in U-Boot and issue:
```
env default -a; saveenv
```

* Insert the created installation media and issue:
```
reset
```
Let the device start w/out any user interactions.

When installers starts, it opens up this message window, let it continue running.

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
          +----------------------------------------------------------+
          |                 <Stop Auto Installer>                    |
          +----------------------------------------------------------+


At the end of the process this message wondow gets shown up, follow the instructions.


              +-------------------Success----------------------+
              | Remove installation media & Press Enter        |
              |                                                |
              |                                                |
              +------------------------------------------------+
              |                 <Press Enter>                  |
              +------------------------------------------------+

Done.
