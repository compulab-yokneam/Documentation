# Deploy the CompuLab Linux Kernel to CompuLab devices

## Compile the Kernel
Follow the instructions of the SoC Linux Kerne Build.
|NOTE|Not covered by this document|
|---|---|

## Create a bzip2 compressed tarball
* Issue ``tarbz2-pkg``
```
make -j`nproc` tarbz2-pkg
```
* Pre Install procedure

|Build Type|Procedure/Command|
|---|---|
|On target|``ln -sf $(readlink -e linux-*.tar.bz2 \| tail -1) /tmp/linux-compulab.tar.bz2``|
|On another device|Copy linux-\<version\>-arm64.tar.bz2 to the target devive /tmp/linux-compulab.tar.bz2|

## Deploy the created image
* Issue CompuLab linux install script as root:
```
sudo -i
bash <(curl -L https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/etc/cl-kernel-install.sh) /tmp/linux-compulab.tar.bz2
```
* Reboot the device.
* When device is up, issue:
<pre>
uname -r
</pre>
Make sure that the reported version matches the original deb package version.
