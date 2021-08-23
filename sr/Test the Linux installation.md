# Test the Linux installation

## [Fedora IoT](https://getfedora.org/en/iot/)
* [Fedora 34](https://download.fedoraproject.org/pub/alt/iot/34/IoT/aarch64/iso/Fedora-IoT-IoT-ostree-aarch64-34-20210801.0.iso)

Step|Requirements
---|---
Installation | Works out of the box
Run time | Requires no changes in any conf files.

## [OpenSuse](https://get.opensuse.org)
* [MicroOS](https://download.opensuse.org/ports/aarch64/tumbleweed/iso/openSUSE-MicroOS-DVD-aarch64-Current.iso)

Step|Requirements
---|---
Installation | Works out of the box
Run time | Requires no changes in any conf files.

* [Leap](https://download.opensuse.org/distribution/leap/15.3/iso/openSUSE-Leap-15.3-DVD-aarch64-Current.iso)

Step|Requirements
---|---
Installation | Works from an sd-card only. Installation kernel does not have the ci_hdrc support.
Run time | Requires kernel update (5.3.18-59.19-default) in order to get the ci_hdrc support.

## Debian

Step|Requirements
---|---
Installation | Works out of the box, but requires manual GRUB installation.
Run time | Runs flawlessly.

* Failure description<br>
Installer runs into the [efivarfs_set_variable: failed to open ... Read-only file system.](https://wiki.debian.org/UEFI#grub-install_unable_to_set_up_boot_variables).

* How to fix<br>
As soon as the installer reports on the failure, open up a shell and issue:
```
mount /dev/mmcblk2p2 /media
mount /dev/mmcblk2p1 /media/boot/efi
for i in /dev /dev/pts /proc /sys /sys/firmware/efi/efivars /run; do mount -o bind $i /media$i; done
cat << eof > media/tmp/grub.install
grub-install -v --no-nvram /dev/mmcblk2
update-grub2
eof
chmod a+x media/tmp/grub.install
chroot /media /tmp/grub.install
```

## Ubuntu Server 20.04
Step|Requirements
---|---
Installation | * Requires 'clk_ignore_unused' to be added as a kernel boot parameter.<br>* Requires manual GRUB installation.
Run time | Requires 'clk_ignore_unused' to be added as a kernel boot parameter.

* How to add 'clk_ignore_unused' permanentally:
1) Stop in grub menu; press 'e'; add 'clk_ignore_unused' at `linux  /boot/vmlinuz ...` command
2) Make the system boot the Linux and issue:<br>```sudo sed -i 's/\(GRUB_CMDLINE_LINUX=".*\)"/\1 clk_ignore_unused "/g' /etc/default/grub```
