# Debian Installer

## Installation media.
* Please choose an installation media: 

| Supported installation devices | sd-card<br>usb-stick |
| :--- | ---: |

* Download the [Debian Installer Image](https://drive.google.com/file/d/1PmHPMfB8vWXEY0mK4lxPLbgxGbJJ-P7w/view?usp=sharing)

* Create an instalation media:
```
xz -dc /path/to/debian-bullseye-armhf-buildd-20211128105400.sdcard.img.xz | sudo dd of=/dev/sdX bs=1M status=progress conv=fsync
```
Make use of the created media for booting the device.

## Installation procedure

| WARNING | All internal data will be destroyed |
| :--- | :--- |

### Automatic procedure

This approach recommended for updating the device imternal media w/out any user instractions.

* Turn on the device, stop in U-Boot and issue:
```
env default -a; saveenv
```

* Insert the created installation media and issue:
```
reset
```
Let the device start w/out any user interactions.

When installer starts, it opens up this message window, let it continue running.

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


At the end of the process this message window gets shown up, follow the instructions.


              +-------------------Success----------------------+
              | Remove installation media & Press Enter        |
              |                                                |
              |                                                |
              +------------------------------------------------+
              |                 <Press Enter>                  |
              +------------------------------------------------+

Done.

### Manual Procedure

* Turn on the device, stop in U-Boot and issue:
```
env default -a
setenv skip_inst yes
```

* Insert the created installation media and issue:
```
boot
```

* As soon as the loging prompt turns out, login to the device and issue:
```
cl-deploy
```

## Customization of the installation media

|This approach allows|installing additional software to the installation media<br>customization of the rootfs<br>
| :--- | :---|

* Issue ```Manual Procedure``` and stop before ```cl-deploy```.

### User customization example
* Install an additional software package from the Debian repository:
```
apt-get update
apt-get install <sw-package>
```

* Install an additional software package from a tarball:
```
tar -C / -xf /path/to/sw-package.tar.bz2
```

* Customization of the rootfs:
<pre>
cat << eof | tee -a /etc/motd

Debian Image Customization Version #1

eof
</pre>

All these changes will be deployed to the destination by ```cl-deploy```.<br>
After being cusomized the media can be used for either ```Atomatic``` or ```Manual``` installation procedure.
