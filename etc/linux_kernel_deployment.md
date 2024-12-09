# Deploy the CompuLab Linux Kernel to CompuLab devices

The deployment procedure depends on the target OS.
|Supported OS|Deployment method|
|---|---|
|Yocto Poky Linux|[tarbz2-pkg deployment](#yocto-poky-linux-tarbz2-pkg-deployment)|
|Debian Linux|[bindeb-pkg deployment](#debian-linux-bindeb-pkg-deployment)|

## Compile the Kernel
Follow the instructions of the SoC Linux Kerne Build.
|NOTE|Not covered by this document|
|---|---|

## Yocto Poky Linux (tarbz2-pkg deployment)

### Create a bzip2 compressed tarball
* Issue ``tarbz2-pkg``
```
make -j`nproc` tarbz2-pkg
```
* Pre Install procedure

|Build Type|Procedure/Command|
|---|---|
|On target|``ln -sf $(readlink -e linux-*.tar.bz2 \| tail -1) /tmp/linux-compulab.tar.bz2``|
|On another device|Copy linux-\<version\>-arm64.tar.bz2 to the target devive /tmp/linux-compulab.tar.bz2|

### Deploy the created image
* Issue CompuLab linux install [script](https://github.com/compulab-yokneam/Documentation/blob/master/etc/cl-kernel-install.sh) as root:
```
sudo -i
bash <(curl -L https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/etc/cl-kernel-install.sh) /tmp/linux-compulab.tar.bz2
```
* Reboot the device.
* When device is up, issue:
<pre>
uname -r
</pre>
Make sure that the reported version matches the package version.

## Debian Linux (bindeb-pkg deployment)

### Create linux-image deb packages
* Issue ``bindeb-pkg``
```
make -j`nproc` bindeb-pkg
```
* Install procedure:
1) Copy the created packages to the device and issue `dpkg -i /path/to/deb/folder/*.deb`
2) Mount the device boot partition.
3) Copy the content of the /usr/lib/linux-image-<version>/compulab/{\*.dtb,\*.dtbo} to the mounted boot partition.
