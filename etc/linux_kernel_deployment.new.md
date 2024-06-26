# Deploy the CompuLab Linux Kernel to CompuLab devices

## Compile the Kernel
Follow the instructions of the SoC Linux Kerne Build.

|SoM Build Instruction|
|--------|
|[ucm-imx8m-mini](https://github.com/compulab-yokneam/meta-bsp-imx8mm/blob/rel_imx_5.4.24_2.1.0-dev/Documentation/linux_kernel_build.md)|
|[cl-som-imx8](https://github.com/compulab-yokneam/meta-bsp-imx8mq/blob/devel-rel_imx_5.4.3_2.0.0/Documentation/linux_kernel_build.md)|
|[cl-som-imx8x](https://mediawiki.compulab.com/w/index.php?title=CL-SOM-iMX8X:_Building_Linux_Kernel)|
|[imx8mplus-family](https://github.com/compulab-yokneam/linux-compulab/edit/linux-compulab_v5.15.32/README.md)|

## Create a bzip2 compressed tarball
<pre>
make -j`nproc` tarbz2-pkg
</pre>

## Deploy the created image
* Copy the ```/tmp/linux-image-<version>.tar.bz2``` to the device.
* Mount ```boot``` partition:
<pre>
bootp=$(findmnt --noheadings --output=SOURCE /)
bootp=${bootp:0:-1}1
umount -l ${bootp}; mount ${bootp} /boot
</pre>
* Deploy the linux-image tarball:
<pre>
tar -C / -xf /path/to/linux-image.tar.bz2
</pre>
* Reboot the device.
* When device is up, issue:
<pre>
uname -r
</pre>
Make sure that the reported version matches the original deb package version.
