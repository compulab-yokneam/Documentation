# Prevent booting unsigned uefi binaries.

|NOTE|The CompuLab Mender solution does use GRUB wherefore the <bootmedia>/EFI/BOOT/bootaa64.efi is in use.|
|---|---|

## Discovered:
1)	The U-Boot does not issue authenticate_image() at bootefi context.
2)	EFI/BOOT/bootaa64.efi.GRUB loads a signed Linux Image to the address that does not match the [IVT table value](https://github.com/nxp-imx/uboot-imx/blob/lf_v2022.04/doc/imx/habv4/script_examples/genIVT.pl#L5)
3)	EFI/BOOT/bootaa64.efi.GRUB passes the control back to the U-Boot, it reports on:<pre>Authenticate image from DDR location 0xcd747000...
Error: Invalid IVT structure
</pre>and continues booting the system.<br>
Have a look at attached boot [log](https://github.com/compulab-yokneam/Documentation/blob/master/mender/mender-hab-boot.log#L123-L128)

## Solution:
To prevent booting unsigned images while issuing bootefi [1-code](https://github.com/compulab-yokneam/u-boot-compulab/commit/964c985b899f8c5707c95540baa9fa671f4597a0) [2-log](https://github.com/compulab-yokneam/Documentation/blob/master/mender/mender-hab-boot.log#L85-L117)<br>
To sing up the relocated kernel Image loaded by [grub](https://github.com/compulab-yokneam/cst-tools/blob/master/imx8/Makefile#L42-L48)

## Implementation:
* [meta-compulab-hab](https://github.com/compulab-yokneam/meta-compulab-hab) + [cst-tools](https://github.com/compulab-yokneam/cst-tools/commits/master/imx8)
* [u-boot-compulab](https://github.com/compulab-yokneam/u-boot-compulab/tree/u-boot-compulab_v2022.04)
