# Deploying a CompuLab kernel package on a running system

This procedure describes how to build the Linux `cpl-tarbz2-pkg` target,
install the resulting archive on a running CompuLab system, and place the
kernel `Image` and CompuLab device-tree files in the root of the boot media's
first partition.

The examples assume that:

- the first media partition is mounted at `/boot/efi`;
- the second media partition is the running root filesystem mounted at `/`;
- the target uses U-Boot to load `Image` and its device tree from the root of
  the first partition; and
- commands on the target are run as `root`.

Device names vary between systems. Verify them before running any command that
mounts or modifies a partition.

## 1. Back up the active boot files

Make the backup before transferring or extracting the new kernel package.
The first partition is too small to hold a second set of boot files, so this
procedure stores the backup under `/var/backups` on the second partition.

On the target, inspect the media layout:

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

If the first partition is not mounted, mount it after confirming its device
name. For example:

```sh
mkdir -p /boot/efi
mount /dev/mmcblk2p1 /boot/efi
```

Confirm that `/boot/efi` is partition 1 and `/` is partition 2:

```sh
BOOT_DEV="$(findmnt -n -o SOURCE /boot/efi)"
ROOT_DEV="$(findmnt -n -o SOURCE /)"

echo "Boot partition: $BOOT_DEV"
echo "Root partition: $ROOT_DEV"
```

Do not continue if the reported layout does not match the target media.

Create the backup on partition 2:

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

Verify the backup and record its location:

```sh
df -h "$BACKUP_DIR"
ls -lh "$BACKUP_DIR"
echo "Boot backup: $BACKUP_DIR"
```

Do not deploy the new package until the existing `Image` and required device
tree files are present in the backup directory.

## 2. Download the kernel package

Download the prebuilt kernel package from the following Google Drive folder: [iotdin-imx8p/6.6.52](https://drive.google.com/drive/folders/1Wg0IL6Mhb_WqAMi94rWBHbqjGSbExJ34).

Download the required `linux-compulab-*-arm64.tar.bz2` archive to the local
computer.

## 3. Transfer the package

Copy the downloaded archive from the local computer to the running target.
Replace the host name and archive name as appropriate:

```sh
scp /path/to/linux-compulab-*-arm64.tar.bz2 root@TARGET_HOST:/tmp/
```

Log in to the target:

```sh
ssh root@TARGET_HOST
```

Select the transferred archive and inspect it before extraction:

```sh
PKG="/tmp/linux-compulab-6.6.52-<time-stamp>-arm64.tar.bz2"
tar -tjf "$PKG" | less
```

## 4. Determine the packaged kernel release

The archive places the new `Image` and CompuLab device trees in a versioned
directory below `/boot/efi`. Obtain that version from the archive:

```sh
KREL="$(tar -tjf "$PKG" | sed -n \
    's#^\(\./\)\?boot/efi/\([^/]*\)/Image$#\2#p' | head -n 1)"

test -n "$KREL" || {
    echo "Unable to determine the kernel release from $PKG" >&2
    exit 1
}

echo "Kernel release: $KREL"
```

## 5. Extract the package

Ensure that partition 1 remains mounted at `/boot/efi`, then extract the
archive into the running root filesystem on partition 2:

```sh
findmnt /boot/efi
tar --numeric-owner -xjf "$PKG" -C /
depmod -a "$KREL"
```

Verify the installed files:

```sh
test -f "/boot/efi/$KREL/Image"
test -d "/lib/modules/$KREL"
find "/boot/efi/$KREL" -maxdepth 1 -type f \
    \( -name 'Image' -o -name '*.dtb' -o -name '*.dtbo' \) -print
```

## 6. Activate the new kernel and device trees

U-Boot expects `Image` and the selected device tree in the root of partition
1. Copy the new kernel through a temporary filename, then install all packaged
CompuLab device trees and overlays:

```sh
KERNEL_DIR="/boot/efi/$KREL"

cp "$KERNEL_DIR/Image" /boot/efi/Image.new
sync
mv -f /boot/efi/Image.new /boot/efi/Image

find "$KERNEL_DIR" -maxdepth 1 -type f \
    \( -name '*.dtb' -o -name '*.dtbo' \) \
    -exec cp -f -t /boot/efi {} +

sync
```

Confirm that the expected files are present:

```sh
ls -lh /boot/efi/Image
find /boot/efi -maxdepth 1 -type f \
    \( -name '*.dtb' -o -name '*.dtbo' \) -print
```

## 7. Select the correct device tree

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

## 8. Reboot and validate

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

## 9. Roll back

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

Restore its kernel and device trees. Replace `BACKUP_TIMESTAMP` with the chosen
directory name:

```sh
RECOVERY_BACKUP=/mnt/rootfs/var/backups/compulab-boot/BACKUP_TIMESTAMP

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
