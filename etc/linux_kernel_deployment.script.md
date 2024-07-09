# Deploy the CompuLab Linux Kernel to CompuLab devices

## Compile the Kernel
Follow the instructions of the SoC Linux Kerne Build.

|SoM Build Instruction|
|--------|
|[imx8mp](https://github.com/compulab-yokneam/linux-compulab/tree/linux-compulab_v6.1.55)|

## Create a bzip2 compressed tarball
<pre>
make -j`nproc` cpl-tarbz2-pkg
ln -sf $(linux-compulab-*.tar.bz2 | tail -1) /tmp/linux-compulab.tar.bz2
</pre>

## Deploy the created image
* Issue CompuLab linux install script:
```
bash <(curl -L https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/etc/cl-kernel-install.sh) /tmp/linux-compulab.tar.bz2
```
* Reboot the device.
* When device is up, issue:
<pre>
uname -r
</pre>
Make sure that the reported version matches the original deb package version.
