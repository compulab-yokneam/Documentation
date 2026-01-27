# CompuLab Nvidia Installer

The purpouse of this procedure is:
* Clean up the device internal ``nvme0n1`` disk:
* Create this partition layout:
```
label: gpt
label-id: 14DCC56A-491E-4D7D-93DD-F1170BA4A855
unit: sectors
first-lba: 40
sector-size: 512

/dev/nvme0n1p1 : start=     3050048, size=   265385368, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, uuid=03330C85-1480-4B1E-A4DA-8A1E5D9318EC, name="APP"
/dev/nvme0n1p2 : start=          40, size=      262144, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, uuid=0FF17FA4-2B9B-47C8-A45B-6E4D124F353E, name="A_kernel"
/dev/nvme0n1p3 : start=      262184, size=        1536, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, uuid=7DFE6690-1988-410A-BB91-41089D45267E, name="A_kernel-dtb"
/dev/nvme0n1p4 : start=      263720, size=       64768, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, uuid=44237A6A-45BF-4CAC-8E7E-60404225D441, name="A_reserved_on_user"
/dev/nvme0n1p5 : start=      328488, size=      262144, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, uuid=5BD17188-F24A-4082-8EEF-460CA5D12352, name="B_kernel"
/dev/nvme0n1p6 : start=      590632, size=        1536, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, uuid=600A31D3-8F43-48AB-9B3F-EF2C20B7010D, name="B_kernel-dtb"
/dev/nvme0n1p7 : start=      592168, size=       64768, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, uuid=07A739EA-24C8-4D8F-99B2-C32C8D4EDB76, name="B_reserved_on_user"
/dev/nvme0n1p8 : start=      656936, size=      163840, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, uuid=6222B927-E760-4282-8B0F-4C3FC3BDBC7E, name="recovery"
/dev/nvme0n1p9 : start=      820776, size=        1024, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, uuid=7F6E7843-0D79-40D3-9B6B-A354E7F75F0F, name="recovery-dtb"
/dev/nvme0n1p10 : start=      821800, size=      131072, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B, uuid=089B3915-C6FF-4211-BA46-954DA59F9906, name="esp"
/dev/nvme0n1p11 : start=      952872, size=      163840, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, uuid=731BE088-D875-45D6-82E5-BF04F25A3F37, name="recovery_alt"
/dev/nvme0n1p12 : start=     1116712, size=        1024, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, uuid=42831E34-6411-4520-B480-1379BC8F541E, name="recovery-dtb_alt"
/dev/nvme0n1p13 : start=     1117736, size=      131072, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, uuid=75A3565B-6F83-455A-A261-78702F88AD55, name="esp_alt"
/dev/nvme0n1p14 : start=     1248832, size=      819200, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, uuid=7E05FEC6-A0BD-4D67-8F3F-AF62B138AD05, name="UDA"
/dev/nvme0n1p15 : start=     2068032, size=      982016, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, uuid=6AF6C585-F168-4F72-BE87-887CAC7E194D, name="reserved"
/dev/nvme0n1p16 : start=   268435416, size=    33554432, type=0657FD6D-A4AB-43C4-84E5-0933C84B4F4F, uuid=3525B6FB-225B-4009-A329-F95836205120, name="swap"
/dev/nvme0n1p17 : start=   301989848, size=   100663297, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=9ACD7CAB-B023-4339-B906-72732F028286, name="storage"
``` 
* Install CompuLab EdgeAI-ORN Ubuntu 22.04.5 LTS with JetPack 6.2

## Linux Desktop procedure:
* Download the installer image file from this [location](https://drive.google.com/drive/folders/1CymTLLvaEH9gTPxypveWm6EoBwkK62z9?usp=drive_link)
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
