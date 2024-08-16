# QEMU how to

## Prerequisites
* Installed qemu-system-aarch64
* Enablded loop device support

## Run Qemu with an os image file
<pre>
sudo -i
bash <(curl -sl https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/etc/howto/qemu.sh) /path/to/os.image
</pre>

## Get connected to the Qemu device console
<pre>
telnel localhost 4446
</pre>

