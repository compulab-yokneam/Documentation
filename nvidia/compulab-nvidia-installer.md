# CompuLab Nvidia Installer

## What this installer does:
* Cleans up the device selected device;
* Creates one of these layouts:
  * NVidia default layout with: APP=\<rest of the media free space\>
  * Nvidia default layout with: APP=\<user-defined-size\>GiB; swap=16GiB; storage=\<rest of the media free space\>
* Deploys the CompuLab EdgeAI-ORN Ubuntu 22.04.5 LTS with JetPack 6.2

## Linux Desktop procedure:
* Download the installer files from this [location](https://drive.google.com/drive/folders/1CymTLLvaEH9gTPxypveWm6EoBwkK62z9?usp=drive_link)
  * After download validation:
    * Issue this command:
      ```
      md5sum /path/to/debian-trixie-arm64-buildd-nvidia.compulab-installer-rw-gpt-sdcard.img
      ```
     * Make sure that the returned value is the as in the \<imagename\>.md5sum file.
       * yes: continue to the next step;
       * no: download the image file again;
      
         |IMPORTANT|Don't go to the next step if md5sum is incorrect|
         |---|---|

 * Create a removable media:

   |NOTE|1) Media size must be more that 32G<br>2)/dev/sdX in the command line example is the entire block device not a partition!!!|
   |---|---|

    ```
    sudo dd if=/path/to/debian-trixie-arm64-buildd-nvidia.compulab-installer-rw-gpt-sdcard.img of=/dev/sdX oflag=dsync bs=1M status=progress
    ```
    |IMPORTANT|It is up to the user to make sure that removable media created w/out errors.<br>Make sure that the media rootfs partition is mountable and the fsck returns no errors.<br>If any of these conditions failed, then recreate the media.|
    |---|---|
    
## Target Device Procedure:
* Power off the device.
* Insert the create media into a device USB3 port.
* Power on the device, and make sure that device boots up from the create usb media.
* The GRUB menu turns out:
  ```
  /----------------------------------------------------------------------------\
  |*Debian GNU/Linux                                                           |
  | Advanced options for Debian GNU/Linux                                      |
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
  device="?" /opt/compulab-nvidia-installer/installer.sh
  1) /dev/nvme0n1
  2) Exit
  Choose device > 1
  Starting install onto the /dev/nvme0n1 ...
  1) layout_01--[01_Nvidia__Layout;__rootfs__till__the__end__of__the__media]
  2) layout_02--[02_Nvidia__Layout;__rootfs=<user_defined_>GiB,__swap=16GiB,__data__partition__till__the__end__of__the__media]
  3) Exit
  Choose layout > 2
  1) 32
  2) 64
  3) 128
  4) Exit
  Choose rootfs size > 3
  .......
  ____                        ___  _  __    _ __   __
  |  _ \  ___  _ __   ___ _   / _ \| |/ /   / \\ \ / /
  | | | |/ _ \| '_ \ / _ (_) | | | | ' /   / _ \\ V / 
  | |_| | (_) | | | |  __/_  | |_| | . \  / ___ \| |  
  |____/ \___/|_| |_|\___(_)  \___/|_|\_\/_/   \_\_|  
                                                     
  ```

  The process can return:

  |Status|Next step|
  |---|---|
  |Done OKAY|power off the device;<br>pull the usb media off;<br>turn the device on again.|
  |Failed|try to figure out what the problem is;<br>fix it;<br>try again.|
