# Deploy the CompuLab Linux Kernel to CompuLab devices

## Compile the Kernel
Follow the instructions of the SoC Linux Kerne Build.
For instance: [imx8mm](https://github.com/compulab-yokneam/meta-bsp-imx8mm/blob/rel_imx_5.4.24_2.1.0-dev/Documentation/linux_kernel_build.md)

## Create deb package
<pre>
make -j`nproc` bindeb-pkg
</pre>

## Transfor the created ```linux-image-<version>-<arch>.deb``` to a tarball
This procedure creates a ready to deploy tarball that meats the CompuLab rootfs layout requirements.
* Linux image file name is 'Image'
* All device tree files are in '/boot' directory

Make use of this script [deb2tar.sh](https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/etc/deb2tar.sh)
<pre>
wget --output-document=/tmp/deb2tar.sh https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/etc/deb2tar.sh
chmod a+x /tmp/deb2tar.sh
/tmp/deb2tar.sh linux-image-*.deb
</pre>

The output file will be saved as  ```/tmp/linux-image-<version>.tar.bz2```.

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
