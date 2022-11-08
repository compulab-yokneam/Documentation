# cl-uboot how to

## interactive mode

* Open up a terminal window and issue cl-uboot"

<pre>
cl-uboot
</pre>

* Select a U-Boot file:

<pre>
Select a U-Boot file:
------------------------------------------------------------------------------------------------------------------


                  l------------------------------------------------------------------------------k
                  x Available U-Boot files:                                                      x
                  x l--------------------------------------------------------------------------k x
                  x x              (*) imx-boot-ucm-imx8m-mini-sd.bin-flash_evk                x x
                  x x                                                                          x x
                  x x                                                                          x x
                  x x                                                                          x x
                  x x                                                                          x x
                  x m--------------------------------------------------------------------------j x
                  t------------------------------------------------------------------------------u
                  x                       <  OK  >            <Cancel>                           x
                  m------------------------------------------------------------------------------j

</pre>

* Select a boot device:

<pre>
Select a boot device:
------------------------------------------------------------------------------------------------------------------


                  l------------------------------------------------------------------------------k
                  x Available boot devices:                                                      x
                  x l--------------------------------------------------------------------------k x
                  x x                            ( ) mmcblk2                                   x x
                  x x                            (*) mmcblk2boot0                              x x
                  x x                            ( ) mmcblk2boot1                              x x
                  x x                                                                          x x
                  x x                                                                          x x
                  x m--------------------------------------------------------------------------j x
                  t------------------------------------------------------------------------------u
                  x                       <  OK  >            <Cancel>                           x
                  m------------------------------------------------------------------------------j
</pre>

* Complete window/screee:

<pre>
mmc bootpart enable 1 0 /dev/mmcblk2boot0;dd if=/boot/imx-boot-ucm-imx8m-mini-sd.bin-flash_evk of=/dev/mmcblk2boot
------------------------------------------------------------------------------------------------------------------


                  l------------------------------------------------------------------------------k
                  x U Boot flash result:                                                         x
                  x------------------------------------------------------------------------------x
                  x 1292+1 records in                                                            x
                  x 1292+1 records out                                                           x
                  x 1323380 bytes (1.3 MB, 1.3 MiB) copied, 0.60582 s, 2.2 MB/s                  x
                  x                                                                              x
                  x                                                                              x
                  x                                                                              x
                  t------------------------------------------------------------------------------u
                  x                                   <  OK  >                                   x
                  m------------------------------------------------------------------------------j
</pre>

* Reboot the device, stop in U-Boot and issue:
* 1) check the U-Boot version
<pre>
version
</pre>
* 2) check the U-Boot location
<pre>
mmc partconf 1
</pre>
<pre>
EXT_CSD[179], PARTITION_CONFIG:
BOOT_ACK: 0x0
BOOT_PARTITION_ENABLE: 0x1
PARTITION_ACCESS: 0x0
</pre>

## non-interactive mode

* Open up a terminal window and issue cl-uboot.quiet"

<pre>
IMX_BOOT=/boot/imx-boot-ucm-imx8m-mini-sd.bin-flash_evk IMX_DEV=/dev/mmcblk2boot0 cl-uboot.quiet
</pre>
