# QEMU how to

## Prerequisites
* Installed qemu-system-aarch64
* Enablded loop device support
* Downloaded the [file](https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/etc/howto/qemu.sh)

## Run Qemu with an os image file
<pre>
chmod a+x /path/to/qemu.sh
sudo /path/to/qemu.sh /path/to/os.image
</pre>

## Get connected to the Qemu console
<pre>
telnel localhost 4446
</pre>

