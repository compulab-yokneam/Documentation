# Prevent booting a 3-d party unsigned bootloader.

|NOTE|The CompuLab Mender solution does use GRUB wherefore the <bootmedia>/EFI/BOOT/bootaa64.efi is in use.|
|---|---|

## Discovered:
1)	The U-Boot does not issue authenticate_image() at bootefi context.
2)	EFI/BOOT/bootaa64.efi.GRUB loads a signed Linux Image to an address that does not match the [IVT table value](https://github.com/nxp-imx/uboot-imx/blob/lf_v2022.04/doc/imx/habv4/script_examples/genIVT.pl#L5)
3)	EFI/BOOT/bootaa64.efi.GRUB passes the control back to the U-Boot, it reports on:<pre>Authenticate image from DDR location 0xcd747000...
Error: Invalid IVT structure
</pre>and continues booting the system.<br>
Have a look at attached boot [log](https://github.com/compulab-yokneam/Documentation/blob/master/mender/mender-hab-boot.log#L123-L128)

## Solution:
To make the U-Boot prevent booting unsigned images while issuing bootefi.<br>
Have a look at attached boot log tahe shows how the u-boot authentificates the bootefi [binary](https://github.com/compulab-yokneam/Documentation/blob/master/mender/mender-hab-boot.log#L85-L117)

## Implementation:
* [meta-compulab-hab](https://github.com/compulab-yokneam/meta-compulab-hab/commit/30484d691af600dd271e559d23ebc66fedeeb8b0)
* [u-boot-compulab](https://github.com/compulab-yokneam/u-boot-compulab/commit/964c985b899f8c5707c95540baa9fa671f4597a0)
