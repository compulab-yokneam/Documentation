# U-Boot Validation

## Memory
* detection
<pre>
meminfo
bdinfo
</pre>
* accessing of all physical memory in u-boot

|!!!| Avoid using the ranges that includes: TLB addr;relocaddr;irq_sp;sp start;FB base|
|---|---|

<pre>
mtest [start [end [pattern [iterations]]]]
</pre>

## Media test
### MMC
* scan<pre>
mmc rescan; mmc list
</pre>

* read<pre>
ls mmc 2
</pre>

### USB
* scan<pre>
usb start; usb info
</pre>

* read<pre>
ls usb 0
</pre>

### SATA

|!!!|```sata init``` causes the u-boot crash if a sata device is not installed|
|---|---|


* scan<pre>
sata init; usb info
</pre>

* read<pre>
ls sata 0
</pre>

### NAND
* scan<pre>
nand info
</pre>

* read<pre>
nand read ${loadaddr} 0 0x8000
</pre>

* write/read/validate<pre>
load usb 0 0x12000000 zImage
nand write 0x12000000 0 ${filesize}
nand read 0x14000000 0 ${filesize}
cmp.b 0x14000000 0x12000000 ${filesize} && echo "Good"
nand read ${loadaddr} 0 0x8000
</pre>

### Boot test
* SD-card
Create an SD-card bootable media and try to boot from:<pre>
run distro_bootcmd
</pre>

* USB<br>Boot up the device using the sd-card and issue:<pre>
DST=/dev/sdb cl-deploy
</pre>

* SATA<br>Boot up the device using the the usb disk and issue:<pre>
DST=/dev/sda cl-deploy
</pre>

* NET Boot:<pre>
setenv sip 192.168.11.170
dhcp; setenv serverip ${sip}; tftpboot ${loadaddr} ${sip}:/cm-fx6/boot.cm-fx6-evk.scr; source ${loadaddr}
</pre>
