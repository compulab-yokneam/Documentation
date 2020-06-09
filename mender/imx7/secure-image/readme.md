# Mender Image manual signing procedure how to

## Signing
* Goto the machine image directory:
<pre>
cd {BUILDDIR}/tmp/deploy/images/${MACHINE}
</pre>

* Input files for signing are at `{BUILDDIR}/tmp/deploy/images/${MACHINE}/cst-tools/hab`:

Important | This folder contains all required files even though the `cst-tools` is not installed onto the image  |
--- | --- |

<pre>
SPL
SPL.log
u-boot-ivt.img
u-boot-ivt.img.log
zImage
</pre>

### Kernel
* Take the `zImage` binary, issue [signing Kernel Image](https://mediawiki.compulab.com/w/index.php?title=IOT-GATE-iMX7_and_SBC-IOT-iMX7:_U-Boot:_Building_Secure_Images#Signing_Kernel_Image). Save the output as `zImage.signed`.

### U-Boot
* Take the boot loader input files, issue [signing U-Boot Firmware](https://mediawiki.compulab.com/w/index.php?title=IOT-GATE-iMX7_and_SBC-IOT-iMX7:_U-Boot:_Building_Secure_Images#Signing_U-Boot_Firmware). Save the output as `u-boot.imx.signed`.

## Mount image file
* Issue: `sdimage to a plain image file`:
<pre>
sudo bmaptool copy core-image-full-cmdline-cl-som-imx7.sdimg /tmp/imx7mender.file
</pre>
* image to a loop device:
<pre>
loopdevice=$(sudo losetup --find --show --partscan /tmp/imx7mender.file)
</pre>

* mount boot & both rootfs partitions
<pre>
mkdir /tmp/{boot,rootfs1,rootfs2}
sudo mount ${loopdevice}p1 /tmp/boot
sudo mount ${loopdevice}p2 /tmp/rootfs1 
sudo mount ${loopdevice}p3 /tmp/rootfs2
</pre>

## Deploy signed binaries

### Kernel
* Save an original `zImage` first:
<pre>
for d in /tmp/boot/ /tmp/rootfs1/boot/ /tmp/rootfs2/boot/;do
mv ${d}/zImage ${d}/zImage.original
done
</pre>

* Copy the signed `zImage.signed` binary to /tmp/boot, /tmp/rootfs1/boot and /tmp/rootfs2/boot/
<pre>
for d in /tmp/boot/ /tmp/rootfs1/boot/ /tmp/rootfs2/boot/;do
cp /path/to/zImage.signed ${d}/
ln -fs zImage.signed  ${d}/zImage
done
</pre>

### U-Boot
* Copy the signed `u-boot.imx.signed` binary to /tmp/rootfs1/boot and /tmp/rootfs2/boot/
<pre>
for d in /tmp/rootfs1/boot/ /tmp/rootfs2/boot/;do
cp /path/to/u-boot.imx.signed ${d}/
ln -sf u-boot.imx.signed ${d}/u-boot.imx
done
</pre>

* Deploy the signed bootloader to the ${loopdevice} 1K offset:
<pre>
sudo dd if=/tmp/rootfs1/boot/u-boot.imx.signed of=${loopdevice} bs=1k seek=1
</pre>

* Unmount all mounted partitions and detach the loopdevice:
<pre>
sudo umount ${loopdevice}p*
sudo losetup –detach ${loopdevice}
</pre>

## Image to sd-card
<pre>
sudo dd if=/tmp/imx7mender.file of=/dev/sdX bs=1M status=progress
</pre>
