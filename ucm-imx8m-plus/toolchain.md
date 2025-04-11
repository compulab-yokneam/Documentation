# Crosstool how to

* Downlaod the compiler:
<pre>
cd ~/Downloads
whet https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/14.2.0/x86_64-gcc-14.2.0-nolibc-aarch64-linux.tar.xz
</pre>

* Install it:
<pre>
xz -dc ~/Downloads/x86_64-gcc-14.2.0-nolibc-aarch64-linux.tar.xz | sudo tar -C /opt -xf -
</pre>

* Set environment variables:
<pre>
export ARCH=arm64
export CROSS_COMPILE=/opt/gcc-14.2.0-nolibc/aarch64-linux/bin/aarch64-linux-
</pre>

* Get the compiler version information.<br>Make sure that the compiler installed and the environment set correctly, issue:
<pre>
${CROSS_COMPILE}gcc --version
aarch64-linux-gcc (GCC) 14.2.0
Copyright (C) 2024 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
</pre>
