# CompuLab Nvidia Installer

## Linux Desktop procedure:
* Download the installer image file from this [location](https://drive.google.com/drive/folders/1CymTLLvaEH9gTPxypveWm6EoBwkK62z9?usp=drive_link)
* Create a removable media:

  |NOTE|1) Media size must be more that 32G<br>2)/dev/sdX in the command line example is the entire block device not a partition!!!|
  |---|---|

  ```
  sudo dd if=/path/to/debian-trixie-arm64-buildd-nvidia.compulab-installer-rw-gpt-sdcard.img of=/dev/sdX bs=1M status=progress
  ```
## Target Device Procedure:
* Power off the device.
* Insert the create media into a device USB3 port.
* Power on the device, and make sure that device boots up from the create usb media.
* The GRUB menu turns out:
  ```
  /----------------------------------------------------------------------------\
  |*Debian GNU/Linux                                                           |
  | Advanced options for Debian GNU/Linux                                      |
  | Debian GNU/Linux (compulab-installer), with Linux 6.6.111-yocto-standard   |
  | Advanced Device Tree Options                                               |
  | UEFI Firmware Settings                                                     |
  \----------------------------------------------------------------------------/
  ```
  Choose ``Debian GNU/Linux``
* Let the device get to the login prompt, and login with the ``compulab`` user name:
  ```
  Debian GNU/Linux 13 compulab-host ttyTCU0
  Default User: compulab

  compulab-host login:
  ```
* Set the ``compulab`` user password at the very 1-st login:
  ```
  compulab-host login: compulab
  You are required to change your password immediately (administrator enforced).
  New password:
  Retype new password:
  ```
* Issue installation procedure:
  ```
  sudo -i
  /opt/compulab-nvidia-installer/installer.sh
  ```
  The process can return:

  |Status|Next step|
  |---|---|
  |Done OKAY|power off the device;<br>pull the usb media off;<br>turn the device on again.|
  |Failed|try to figure out what the problem is;<br>fix it;<br>try again.|
