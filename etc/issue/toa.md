# u-boot-compulab with two dram subsets d2d4/d1d8.

CompuLab U-Boot started running in the spl overflow issue with providing more lpddr4 timing for the D2D4 subset.

Here is what compiler reports about:
```
u-boot-spl section `.data' will not fit in region `.sram'
region `.sram' overflowed by 63376 bytes
```

Solution is to set:
```
CONFIG_SPL_MAX_SIZE=0x2C000
CONFIG_SPL_PAD_TO=0x2C000
```

It works w/out an issue if the flash.bin target created using BINMAN approach.
|Discovered|The Yocto imx-mkimage approach creates a corrupted boot loader. As a result device can’t pass the DRAM in SPL memory training and hangs|
|:---|:---|

# Provided solution.

## Solution #1 (implemented in the latest release):
Split D2D4 into D2, D4 that allows reduce the SPL size:
* u-boot: https://github.com/compulab-yokneam/u-boot-compulab/tree/facddf8faa629f07cffb2dae8b92d6f6a96e9583
  * u-boot recipe, preserves the default 0x26000 SPL size: https://github.com/compulab-yokneam/meta-bsp-imx8mp/blob/iot-gate-imx8plus-r3.2/recipes-bsp/u-boot/u-boot-compulab/imx8mp.inc
    spl_size.cfg fragment is removed.
* meta-layer: https://github.com/compulab-yokneam/meta-bsp-imx8mp/tree/iot-gate-imx8plus-r3.2

## Solution #2 (to be released):
Use the D2D4, D1D8 subset with expanded SPL size:
* u-boot: https://github.com/compulab-yokneam/u-boot-compulab/tree/u-boot-compulab_v2023.04-d1d8_d2d4
* metal-layer: https://github.com/compulab-yokneam/meta-bsp-imx8mp/blob/wrynose-6.18.20-2.0.0
  * machine configuration: https://github.com/compulab-yokneam/meta-bsp-imx8mp/blob/wrynose-6.18.20-2.0.0/conf/machine/compulab-imx8mp.inc#L15

# Mender
1. The device tree in U-Boot is not a part of the device boot loader.  It is a part of the A/B kernel. 
2. The device U-Boot uses the boot partition dtb for issuing this U-boot botcmd: ``bootefi ${loadaddr} - ${fdt_addr}``
3. In the past we have implemented the approach that allows booting the device tree from the Linux kernel location:
  https://github.com/compulab-yokneam/meta-mender-compulab/commit/6e285066eb39f275045b3308efa0c7949a11bcf3
4. The reason why Mender does not have this logic in grub implementation is unclear.
5. Mender offers two implementations:
* U-Boot is untouched:
  * all mender logic is in the grub.cfg file.
  * boot command loads the grubuefi with the dtb file from the boot partition.
  * The grub uses the grub.cfg logic in order to select the bootable Linux kernel partition, then it loads the Linux kernel and passes the control to.

* U-Boot is modified:
  * all mender logic is in the U-Boot environment inside the U-Boot binary.
  * The U-Boot boot command loads the Linux kernel and its device tree from the same partition calculated by the Mender  logic.

CompuLab supports this approach by this branch:
https://github.com/compulab-yokneam/meta-mender-compulab/tree/scarthgap-nxp-uboot
