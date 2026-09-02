# Cortex-M7 DDR execution on UCM-iMX95

The Cortex-M7 in the i.MX95 can execute applications from external DDR, so applications are not limited to the available TCM/SRAM capacity. NXP's MCUXpresso DDR targets are therefore applicable to the UCM-iMX95 at the SoC level.

SD/eMMC is used only to store the boot container. During boot, OEI initializes DDR, the boot flow copies the M7 firmware from the boot container into DDR, and System Manager starts the M7. The application does not execute directly from SD/eMMC.

The NXP EVK `flash.bin` should not be used unchanged. A new image must be generated using artifacts from the matching CompuLab BSP release, including:

- CompuLab System Manager configuration
- OEI and DDR timing matching the SOM's DDR type and capacity
- CompuLab U-Boot/SPL
- ATF, OP-TEE and AHAB firmware
- The MCUXpresso M7 application built using its DDR linker target and installed as `m7_image.bin`

For an M7-only DDR boot, [use](https://github.com/nxp-imx/imx-mkimage/blob/lf-6.18.20_2.0.0/iMX95/soc.mak#L440):

```text
make SOC=iMX95 REV=<soc-revision> OEI=YES \
     LPDDR_TYPE=<lpddr5|lpddr4x> \
     flash_lpboot_sm_m7_ddr
```

To boot Linux on the A55 cores together with an M7 application executing from DDR, [use](https://github.com/nxp-imx/imx-mkimage/blob/lf-6.18.20_2.0.0/iMX95/soc.mak#L453):

```text
make SOC=iMX95 REV=<soc-revision> OEI=YES \
     LPDDR_TYPE=<lpddr5|lpddr4x> \
     flash_all_ddr
```

The resulting `flash.bin` can then be written to SD/eMMC at the 32 KiB offset using the normal CompuLab flashing procedure.

When Linux runs together with the M7, the M7 DDR area must be excluded from Linux-managed RAM. The CompuLab BSP provides this reservation in:

[``arch/arm64/boot/dts/compulab/imx95-rpmsg.dtsi``](https://github.com/compulab-yokneam/linux-compulab/blob/linux-compulab_v6.12.34/arch/arm64/boot/dts/compulab/imx95-rpmsg.dtsi#L7)

It contains:

```dts
reserved-memory {
    #address-cells = <2>;
    #size-cells = <2>;

    m7_reserved: m7@80000000 {
        no-map;
        reg = <0 0x80000000 0 0x1000000>;
    };
};
```

This reserves the address range starting at `0x80000000` with a size of `0x01000000`, which is 16 MiB. The `no-map` property prevents Linux from using or normally mapping this region.

This definition is included by:

[``arch/arm64/boot/dts/compulab/imx95-rpmsg.dtso``](https://github.com/compulab-yokneam/linux-compulab/blob/linux-compulab_v6.12.34/arch/arm64/boot/dts/compulab/imx95-rpmsg.dtso)

```text
arch/arm64/boot/dts/compulab/imx95-rpmsg.dtso
```

and the kernel [Makefile](https://github.com/compulab-yokneam/linux-compulab/blob/linux-compulab_v6.12.34/arch/arm64/boot/dts/compulab/Makefile.ucm-imx95#L10) composes the final DTB as follows:

```make
ucm-imx95-rpmsg-dtbs := ucm-imx95-som.dtb \
        imx95-rpmsg.dtbo

dtb-$(CONFIG_ARCH_MXC) += ucm-imx95-rpmsg.dtb
```

Therefore, the 16 MiB reservation is present when Linux boots with `ucm-imx95-rpmsg.dtb`. It is not automatically present in the default `ucm-imx95-som.dtb`.

If the M7 firmware and its runtime DDR sections exceed 16 MiB, the following must be updated together:

- The Linux reserved-memory layout
- The M7 linker script
- System Manager memory permissions
- Any adjacent RPMsg or audio reserved-memory regions

NXP EVK examples that use only CPU and memory functionality should be readily portable. Examples using board peripherals may require UCM-iMX95-specific pinmux, clock and peripheral configuration.

NXP references:

- [MCUXpresso procedure](https://mcuxpresso.nxp.com/mcuxsdk/25.12.00/html/boards/i.MX/imx95lpd5evk19/gettingStarted/topics/run_a_demo_application.html)
- [imx-mkimage i.MX95 targets](https://github.com/nxp-imx/imx-mkimage/blob/lf-6.18.20_2.0.0/Readme.imx95)

CompuLab references:
- [EVAL-UCM-iMX95-2.0](https://github.com/compulab-yokneam/meta-bsp-imx95/tree/walnascar-6.12.34-2.1.0-EVAL-UCM-iMX95-2.0)
