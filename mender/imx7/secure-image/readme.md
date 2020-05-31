# Mender Image signing procedure how to

* sdimage to a plain image:
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

* The Kernel file to be signed and copied back to the media:
<pre>
ls -al /tmp/boot/zImage /tmp/rootfs1/boot/zImage /tmp/rootfs2/boot/zImage
/tmp/boot/zImage
/tmp/rootfs1/boot/zImage-4.19.35+g0f9917c56d59
/tmp/rootfs2/boot/zImage-4.19.35+g0f9917c56d59
</pre>

* Take the /tmp/boot/zImage binary, issue [signing Kernel Image](https://mediawiki.compulab.com/w/index.php?title=IOT-GATE-iMX7_and_SBC-IOT-iMX7:_U-Boot:_Building_Secure_Images#Signing_Kernel_Image)
and copy the signed binary back to /tmp/boot, /tmp/rootfs1/boot and /tmp/rootfs2/boot/

* The bootloader file to be signed and copied back to the media:
<pre>
ls -al /tmp/rootfs1/boot/u-boot-cl-som-imx7-2018.11-r0.imx /tmp/rootfs2/boot/u-boot-cl-som-imx7-2018.11-r0.imx
/tmp/rootfs1/boot/u-boot-cl-som-imx7-2018.11-r0.imx
/tmp/rootfs2/boot/u-boot-cl-som-imx7-2018.11-r0.imx
</pre>

* Take the /tmp/rootfs1/boot/u-boot-cl-som-imx7-2018.11-r0.imx binary, issue [signing U-Boot Firmware](https://mediawiki.compulab.com/w/index.php?title=IOT-GATE-iMX7_and_SBC-IOT-iMX7:_U-Boot:_Building_Secure_Images#Signing_U-Boot_Firmware)
and copy the signed binary back to /tmp/rootfs1/boot and /tmp/rootfs2/boot/


* Deploy the signed bootloader to the ${loopdevice} 1K offset:
<pre>
sudo dd if=/tmp/rootfs1/boot/u-boot-cl-som-imx7-2018.11-r0.imx of=${loopdevice} bs=1k seek=1
</pre>

* Unmount all mounted partitions and deploy the image to an sd-card:
<pre>
sudo umount ${loopdevice}p*
sudo losetup –detach ${loopdevice}
sudo dd if=/tmp/imx7mender.file of=/dev/sdX bs=1M status=progress
</pre>
