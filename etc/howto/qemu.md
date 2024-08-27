# QEMU how to

## Prerequisites
* Installed qemu-system-aarch64
* Enablded loop device support

## Run Qemu with an os image file
### On console mode:
* Command to issue:
<pre>
sudo -i
bash <(curl -sl https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/etc/howto/qemu.sh) /path/to/os.image
</pre>
|NOTE|Use ```Ctrl-a h``` for help|
|---|---|


### Console through telnet:
* Command to issue:
<pre>
sudo -i
bash <(curl -sl https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/etc/howto/qemu.sh) /path/to/os.image 2
</pre>

* Get connected to the device console:
<pre>
telnet localhost 4446
</pre>

## Etc
* [Script source](https://github.com/compulab-yokneam/Documentation/blob/master/etc/howto/qemu.sh)
