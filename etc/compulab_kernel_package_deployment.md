# Deploying a CompuLab kernel package on a running system

This procedure describes how to install a Linux package created by the
`cpl-tarbz2-pkg` target on a running CompuLab system. The package is first
extracted onto the media's second partition so that extraction does not fill
the small boot partition. The active kernel `Image` and CompuLab device-tree
files are backed up and replaced only after extraction is complete.

The examples assume that:

- the first media partition contains the files loaded by U-Boot and is mounted
  at `/boot/efi` only when it is being backed up or updated;
- the second media partition is the running root filesystem mounted at `/`;
- U-Boot loads `Image` and its device tree from the root of the first
  partition; and
- commands on the target are run as `root`.

Device names vary between systems. Verify them before running any command that
mounts or modifies a partition.

## 1. Download the kernel package

Download the prebuilt kernel package from the following Google Drive folder:

<https://drive.google.com/drive/folders/1Wg0IL6Mhb_WqAMi94rWBHbqjGSbExJ34>

Download the required `linux-compulab-*-arm64.tar.bz2` archive to the local
computer.

## 2. Transfer the package

Copy the downloaded archive to `/var/tmp` on the running target. `/var/tmp`
must reside on the second partition; do not copy the archive to the first
partition.

Replace the host name and archive name as appropriate:

```sh
scp /path/to/linux-compulab-*-arm64.tar.bz2 root@TARGET_HOST:/var/tmp/
```

Log in to the target:

```sh
ssh root@TARGET_HOST
```

Select the transferred archive and inspect it before extraction:

```sh
PKG="/var/tmp/linux-compulab-6.6.52-<time-stamp>-arm64.tar.bz2"

test -f "$PKG"
tar -tjf "$PKG" | less
```

## 3. Automatic installation

The [`cl-kernel-install.sh`](cl-kernel-install.sh) script automates the
partition handling, backup, cleanup, package extraction, and boot-file
installation described in the manual procedure below. Use either this chapter
or the manual installation chapters; do not run both procedures for the same
package.

The automation requires the following media layout:

- the running root filesystem is partition 2;
- the boot filesystem is partition 1 of the same media;
- the root device name ends in `2`, for example `/dev/mmcblk2p2`, because the
  script derives the boot device by replacing that final character with `1`;
- `/var/tmp`, `/boot`, and `/lib/modules` reside on partition 2; and
- `fw_printenv`, `findmnt`, `tar`, `gunzip`, and the other utilities used by
  the script are installed.

Verify the partition layout before running the installer:

```sh
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS
findmnt /
findmnt -T /var/tmp
fw_printenv fdtfile image
```

For example, the expected eMMC layout may be:

```text
/dev/mmcblk2p1  -> boot filesystem
/dev/mmcblk2p2  -> /
```

Confirm that the current `fdtfile` value names a device tree contained in the
package. The installer uses this value to locate the device-tree directory and
will fail if the named file is absent from the archive.

Run the installer as `root`, passing it the package selected in section 2:

```sh
bash -ex <(curl -fL \
    https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/etc/cl-kernel-install.sh) \
    "$PKG"
```

This command downloads and executes the current version of the installer from
the CompuLab Documentation repository. On systems that require a reviewed or
fixed script revision, download and inspect the script before executing it as
`root`.

The installer performs the following operations:

1. Derives partition 1 from the device containing the partition-2 root
   filesystem, unmounts partition 1 if necessary, and mounts it temporarily.
2. Backs up the active kernel, device trees, and related boot files to
   `/boot/kernel-backup.d/$(uname -r)` on partition 2.
3. Saves the current `image` and `fdtfile` U-Boot settings and, when `mkimage`
   is available, creates a recovery boot script on partition 1.
4. Removes the old kernel and device-tree files from partition 1, freeing
   space before installing their replacements.
5. Extracts the kernel archive into the root filesystem on partition 2.
6. Decompresses the packaged `vmlinuz` into a new `Image`, copies it and the
   matching CompuLab device trees to partition 1, and unmounts partition 1.

The automatic backup location differs from the `/var/backups` location used by
the manual procedure. Preserve `/boot/kernel-backup.d/$(uname -r)` until the
new kernel has been validated.

Do not reboot unless the script reports that the kernel was deployed
successfully. Then reboot the target:

```sh
reboot
```

If the system stops at the U-Boot prompt, run the command reported by the
installer:

```text
run bsp_bootcmd
```

After Linux starts, verify the running kernel:

```sh
uname -r
test -d "/lib/modules/$(uname -r)"
cat /proc/device-tree/model
```

The original automation example is also available in the
[general CompuLab kernel deployment procedure](linux_kernel_deployment.md#deploy-the-created-image).

## Manual installation

The remaining chapters describe the equivalent procedure using individual
commands.

## 4. Verify the partition layout and unmount partition 1

Inspect the media layout:

```sh
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS
findmnt /
findmnt /boot/efi
```

For example, the expected eMMC layout may be:

```text
/dev/mmcblk2p1  -> /boot/efi
/dev/mmcblk2p2  -> /
```

Record the device containing partition 1 before unmounting it:

```sh
BOOT_DEV="$(findmnt -n -o SOURCE /boot/efi)"
ROOT_DEV="$(findmnt -n -o SOURCE /)"

echo "Boot partition: $BOOT_DEV"
echo "Root partition: $ROOT_DEV"
```

Confirm that `BOOT_DEV` is partition 1 and `ROOT_DEV` is partition 2 of the
same media. Do not continue if the layout is different or uncertain.

Also confirm that `/var/tmp` is stored on partition 2 and has enough free space
for both the compressed package and the extracted package:

```sh
findmnt -T /var/tmp
df -h /var/tmp
```

Unmount partition 1 before extracting the package:

```sh
umount /boot/efi
mkdir -p /boot/efi

findmnt -T /boot/efi
df -h /boot/efi
```

After the unmount, `/boot/efi` must resolve to the root filesystem on partition
2. This is what causes the packaged boot files to be extracted onto partition
2 rather than the small first partition.

## 5. Determine the packaged kernel release

The archive contains the new `Image` and CompuLab device trees in a versioned
`boot/efi` directory. Obtain that version from the archive:

```sh
KREL="$(tar -tjf "$PKG" | sed -n \
    's#^\(\./\)\?boot/efi/\([^/]*\)/Image$#\2#p' | head -n 1)"

test -n "$KREL" || {
    echo "Unable to determine the kernel release from $PKG" >&2
    exit 1
}

echo "Kernel release: $KREL"
```

## 6. Extract the package onto partition 2

Extract the package while partition 1 remains unmounted:

```sh
STAGED_BOOT="/var/tmp/compulab-boot-$KREL"

test ! -e "$STAGED_BOOT" || {
    echo "$STAGED_BOOT already exists; move or remove it before continuing" >&2
    exit 1
}

tar --numeric-owner -xjf "$PKG" -C /
```

The modules and other root-filesystem content are now installed on partition
2. The boot payload is temporarily located beneath the unmounted `/boot/efi`
mount point, which is also on partition 2. Move that payload out of the mount
point before mounting partition 1:

```sh
test -f "/boot/efi/$KREL/Image"
test -d "/lib/modules/$KREL"

mv "/boot/efi/$KREL" "$STAGED_BOOT"
depmod -a "$KREL"
```

Verify the staged boot files:

```sh
find "$STAGED_BOOT" -maxdepth 1 -type f \
    \( -name 'Image' -o -name '*.dtb' -o -name '*.dtbo' \) -print
```

Do not mount partition 1 until the new `Image` and the required device trees
are visible in `STAGED_BOOT`.

## 7. Mount partition 1 and back up the active boot files

Mount the verified first partition:

```sh
mount "$BOOT_DEV" /boot/efi
findmnt /boot/efi
```

The backup must remain on partition 2 because partition 1 is too small to hold
both the old and new boot files. Create the backup under `/var/backups`:

```sh
BACKUP_DIR="/var/backups/compulab-boot/$(date +%Y%m%d-%H%M%S)"

mkdir -p "$BACKUP_DIR"
chmod 700 "$BACKUP_DIR"

cp -a /boot/efi/Image "$BACKUP_DIR"/

find /boot/efi -maxdepth 1 -type f \
    \( -name '*.dtb' -o -name '*.dtbo' \) \
    -exec cp -a -t "$BACKUP_DIR" {} +

sync
```

Verify that the backup is on partition 2 and contains the active kernel and
device trees:

```sh
findmnt -T "$BACKUP_DIR"
df -h "$BACKUP_DIR"
ls -lh "$BACKUP_DIR"
test -s "$BACKUP_DIR/Image"
echo "Boot backup: $BACKUP_DIR"
```

Do not remove anything from partition 1 until this backup has been verified.

## 8. Free space on partition 1

Remove only the active kernel, device trees, and overlays that were backed up.
Do not remove bootloader or other unrelated files from partition 1.

```sh
rm -f /boot/efi/Image

find /boot/efi -maxdepth 1 -type f \
    \( -name '*.dtb' -o -name '*.dtbo' \) \
    -exec rm -f -- {} +

sync
df -h /boot/efi
```

The old files are now recoverable from `BACKUP_DIR` on partition 2, while
partition 1 has room for the new files.

## 9. Copy the new boot files to partition 1

Check that the staged payload fits in the available space:

```sh
REQUIRED_KB="$(du -sk "$STAGED_BOOT" | awk '{print $1}')"
AVAILABLE_KB="$(df -Pk /boot/efi | awk 'NR == 2 {print $4}')"

echo "Required space:  $REQUIRED_KB KiB"
echo "Available space: $AVAILABLE_KB KiB"

test "$REQUIRED_KB" -le "$AVAILABLE_KB" || {
    echo "The new boot files do not fit on partition 1" >&2
    exit 1
}
```

Copy the kernel through a temporary filename, then copy the CompuLab device
trees and overlays:

```sh
cp "$STAGED_BOOT/Image" /boot/efi/Image.new
sync
mv /boot/efi/Image.new /boot/efi/Image

find "$STAGED_BOOT" -maxdepth 1 -type f \
    \( -name '*.dtb' -o -name '*.dtbo' \) \
    -exec cp -f -t /boot/efi {} +

sync
```

Confirm that the expected files are present:

```sh
ls -lh /boot/efi/Image
find /boot/efi -maxdepth 1 -type f \
    \( -name '*.dtb' -o -name '*.dtbo' \) -print
df -h /boot/efi
```

## 10. Select the correct device tree

The `fdtfile` U-Boot environment variable must name the device tree for the
specific CompuLab module and carrier board. Inspect its current value before
changing it:

```sh
fw_printenv fdtfile
```

When a change is required and the CompuLab environment utility is available,
set it from Linux. For example:

```sh
cl_setenv fdtfile iotdin-imx8p.dtb
```

Alternatively, set it from the U-Boot prompt:

```text
setenv fdtfile iotdin-imx8p.dtb
saveenv
```

The filename above is only an example. Select a DTB that matches the actual
module and carrier. CompuLab's platform how-to documentation describes the
`fdtfile` setting:

<https://mediawiki.compulab.com/w/index.php?title=UCM-iMX8M-Plus%3A_Yocto_Linux%3A_How-To_Guide>

## 11. Reboot and validate

Reboot the target:

```sh
reboot
```

After it starts, confirm that the running release matches the package and that
its module directory exists:

```sh
uname -r
test -d "/lib/modules/$(uname -r)"
cat /proc/device-tree/model
```

Check the kernel log for boot, device-tree, or module errors:

```sh
dmesg | less
```

After the new kernel has been fully validated, the staged boot directory under
`/var/tmp` may be removed to recover space on partition 2. Retain the backup
under `/var/backups` until rollback is no longer required.

## 12. Roll back a manual installation

Because the backup is stored on partition 2, a system that cannot boot the new
kernel may need to be started from recovery media. From the recovery system,
mount both partitions, replacing the example device names as necessary:

```sh
mkdir -p /mnt/rootfs /mnt/boot
mount /dev/mmcblk2p2 /mnt/rootfs
mount /dev/mmcblk2p1 /mnt/boot
```

Locate the required backup:

```sh
find /mnt/rootfs/var/backups/compulab-boot -mindepth 1 -maxdepth 1 \
    -type d -print
```

Replace `BACKUP_TIMESTAMP` with the chosen directory name, clear the current
kernel and device trees, and restore the backup:

```sh
RECOVERY_BACKUP=/mnt/rootfs/var/backups/compulab-boot/BACKUP_TIMESTAMP

test -s "$RECOVERY_BACKUP/Image"

rm -f /mnt/boot/Image
find /mnt/boot -maxdepth 1 -type f \
    \( -name '*.dtb' -o -name '*.dtbo' \) \
    -exec rm -f -- {} +

cp -a "$RECOVERY_BACKUP/Image" /mnt/boot/Image
find "$RECOVERY_BACKUP" -maxdepth 1 -type f \
    \( -name '*.dtb' -o -name '*.dtbo' \) \
    -exec cp -a -t /mnt/boot {} +

sync
umount /mnt/boot
umount /mnt/rootfs
```

Restore the previous `fdtfile` U-Boot value as well if it was changed during
deployment.

## Secure-boot note

Do not replace boot files manually on a secure-boot-enabled system unless the
new kernel and other required artifacts have been signed for that system's
chain of trust. An unsigned or incorrectly signed kernel may leave the target
unable to boot.
