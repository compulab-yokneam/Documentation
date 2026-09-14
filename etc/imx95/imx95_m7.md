# Cortex-M7 on UCM-iMX95

The Cortex-M7 can run firmware from its internal TCM or from external DDR.
The CompuLab BSP deploys the artifacts needed to rebuild the boot container,
select an M7 application, or leave the M7 under U-Boot/Linux control.

> **Note:** The UCM-iMX95 configuration described here uses SoC revision `B0`
> and `LPDDR_TYPE=lpddr5`.

## Serial consoles

Use 115200 baud, 8 data bits, no parity, one stop bit, and no flow control.

| Core | Debug UART | Connector |
| --- | --- | --- |
| Cortex-A55 (U-Boot/Linux) | LPUART1 | P3 |
| Cortex-M33 (System Manager) | LPUART2 | P19: pin 2 RX, pin 4 TX, pin 8 GND |
| Cortex-M7 | LPUART3 | P20: pin 2 RX, pin 4 TX, pin 8 GND |

Connect the adapter TX signal to the board RX signal and the adapter RX signal
to the board TX signal. Connect GND; do not connect the adapter supply pin.

## Optional: rebuilding firmware components (power users only)

Most users should skip this section and use the artifacts already deployed by
BitBake. It is intended only for power users who need to rebuild OEI or System
Manager from source.

Configure the Arm bare-metal toolchain:

```bash
export CROSS_COMPILE=/opt/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-
export SM_CROSS_COMPILE=${CROSS_COMPILE}
export OEI_CROSS_COMPILE=${CROSS_COMPILE}
export TOOLS=/opt/compulab/imx-oei
export ARCH=arm
sudo mkdir -p "${TOOLS}"
sudo ln -sfn "$(dirname "$(dirname "${SM_CROSS_COMPILE}")")" "${TOOLS}/"
```

For the LPDDR5 configuration, build the DDR and TCM OEI images:

```bash
make -j 32 board=mx95lp5 DEBUG=1 DDR_CONFIG=lpddr5_timing \
     r=B0 oei=ddr
make -j 32 board=mx95lp5 DEBUG=1 DDR_CONFIG=lpddr5_timing \
     r=B0 oei=tcm
```

The OEI board, timing configuration, DDR type and capacity must match the SOM.

Build the CompuLab System Manager configuration:

```bash
make -j 32 V=y M=2 config=mx95cpl cfg
make -j 32 V=y M=2 config=mx95cpl
```

Building ATF, OP-TEE and U-Boot is outside the scope of this page.

## Using imx-boot-tools

The [CompuLab i.MX95 BSP development branch](https://github.com/compulab-yokneam/meta-bsp-imx95/tree/wrynose-6.18.20-2.0.0-devel)
provides the ready-to-use `imx-boot-tools` Makefile procedure described below.

After building `imx-boot`, enter the deployed tools directory:

```bash
cd <build-dir>/tmp/deploy/images/ucm-imx95/imx-boot-tools
```

This directory contains the artifacts required to rebuild `flash.bin` without
rebuilding the complete Yocto image.

### Selecting M7 firmware

The default `m7_image.bin` link selects the firmware configured by the Yocto
machine. To choose another compatible 19x19 TCM application from the adjacent
`mcore-demos` directory, run:

```bash
./m7-set.sh
```

The selected firmware is copied into `imx-boot-tools`, and `m7_image.bin` is
updated to point to it.

### Building an image that starts M7 automatically

`flash_all` embeds the selected TCM firmware and starts the M7 during system
boot. Run `clean` first to remove outputs from an earlier invocation:

```bash
make SOC=iMX95 REV=B0 OEI=YES LPDDR_TYPE=lpddr5 clean
make SOC=iMX95 REV=B0 OEI=YES LPDDR_TYPE=lpddr5 flash_all
mv flash.bin flash-ucm-imx95-m7-autostart.bin
```

### Building an image that leaves M7 under A55 control

`flash_a55` omits the M7 firmware and leaves the M7 under U-Boot or Linux
control:

```bash
make SOC=iMX95 REV=B0 OEI=YES LPDDR_TYPE=lpddr5 flash_a55
mv flash.bin flash-ucm-imx95-a55-controlled-m7.bin
```

The resulting image can be written to SD/eMMC at the 32 KiB offset using the
normal CompuLab flashing procedure.

## Loading and starting M7 firmware from U-Boot

Boot with the `flash_a55` image. Copy a TCM-linked
`imx95-19x19-evk_m7_TCM*.bin` firmware file to the FAT boot partition, stop at
the U-Boot prompt, and run:

```text
=> prepaux 1
=> load mmc ${mmcdev}:${mmcpart} ${loadaddr} <m7-firmware>.bin
=> cp.b ${loadaddr} 0x203c0000 ${filesize}
=> dcache flush
=> bootaux 0 1
```

`0x203c0000` is the Cortex-A55-visible M7 TCM boot address. The first `0` in
`bootaux 0 1` is the firmware entry address in the M7 address view, and core ID
`1` selects the M7. The firmware must be linked for M7 TCM and must fit in the
512 KiB TCM window. Its output appears on LPUART3 at P20.

If the M7 is already running, stop it before preparing and loading another
image:

```text
=> stopaux 1
```

An M7 image embedded by `flash_all` is already running before U-Boot. Use
`flash_a55` when U-Boot must load and start the firmware.

### Preserving M7 resources while Linux boots

When an M7 application remains running while Linux boots, append the resource
retention arguments without removing existing options such as
`fbcon=nodefer`:

```text
=> setenv boot_opt "${boot_opt} clk_ignore_unused pd_ignore_unused"
=> saveenv
```

Omit `saveenv` if the setting is required only for the current boot.

## Executing M7 firmware from DDR

The Cortex-M7 in the i.MX95 can execute applications from external DDR, so
applications are not limited to the available TCM/SRAM capacity. NXP's
MCUXpresso DDR targets are therefore applicable to the UCM-iMX95 at the SoC
level.

SD/eMMC is used only to store the boot container. During boot, OEI initializes
DDR, the boot flow copies the M7 firmware from the boot container into DDR, and
System Manager starts the M7. The application does not execute directly from
SD/eMMC.

The NXP EVK `flash.bin` should not be used unchanged. A new image must be
generated using artifacts from the matching CompuLab BSP release, including:

- CompuLab System Manager configuration
- OEI and DDR timing matching the SOM's DDR type and capacity
- CompuLab U-Boot/SPL
- ATF, OP-TEE and AHAB firmware
- The MCUXpresso M7 application built using its DDR linker target and installed
  as `m7_image.bin`

For an M7-only DDR boot, [use](https://github.com/nxp-imx/imx-mkimage/blob/lf-6.18.20_2.0.0/iMX95/soc.mak#L440):

```text
make SOC=iMX95 REV=B0 OEI=YES LPDDR_TYPE=lpddr5 \
     flash_lpboot_sm_m7_ddr
```

To boot Linux on the A55 cores together with an M7 application executing from
DDR, [use](https://github.com/nxp-imx/imx-mkimage/blob/lf-6.18.20_2.0.0/iMX95/soc.mak#L453):

```text
make SOC=iMX95 REV=B0 OEI=YES LPDDR_TYPE=lpddr5 \
     flash_all_ddr
```

### Linux DDR reservation

When Linux runs together with the M7, the M7 DDR area must be excluded from
Linux-managed RAM. The CompuLab BSP provides this reservation in:

[`arch/arm64/boot/dts/compulab/imx95-rpmsg.dtsi`](https://github.com/compulab-yokneam/linux-compulab/blob/linux-compulab_v6.12.34/arch/arm64/boot/dts/compulab/imx95-rpmsg.dtsi#L7)

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

This reserves the address range starting at `0x80000000` with a size of
`0x01000000`, which is 16 MiB. The `no-map` property prevents Linux from using
or normally mapping this region.

This definition is included by:

[`arch/arm64/boot/dts/compulab/imx95-rpmsg.dtso`](https://github.com/compulab-yokneam/linux-compulab/blob/linux-compulab_v6.12.34/arch/arm64/boot/dts/compulab/imx95-rpmsg.dtso)

The kernel [Makefile](https://github.com/compulab-yokneam/linux-compulab/blob/linux-compulab_v6.12.34/arch/arm64/boot/dts/compulab/Makefile.ucm-imx95#L10)
composes the final DTB as follows:

```make
ucm-imx95-rpmsg-dtbs := ucm-imx95-som.dtb \
        imx95-rpmsg.dtbo

dtb-$(CONFIG_ARCH_MXC) += ucm-imx95-rpmsg.dtb
```

Therefore, the 16 MiB reservation is present when Linux boots with
`ucm-imx95-rpmsg.dtb`. It is not automatically present in the default
`ucm-imx95-som.dtb`.

If the M7 firmware and its runtime DDR sections exceed 16 MiB, the following
must be updated together:

- The Linux reserved-memory layout
- The M7 linker script
- System Manager memory permissions
- Any adjacent RPMsg or audio reserved-memory regions

NXP EVK examples that use only CPU and memory functionality should be readily
portable. Examples using board peripherals may require UCM-iMX95-specific
pinmux, clock and peripheral configuration.

## References

- [MCUXpresso procedure](https://mcuxpresso.nxp.com/mcuxsdk/25.12.00/html/boards/i.MX/imx95lpd5evk19/gettingStarted/topics/run_a_demo_application.html)
- [imx-mkimage i.MX95 targets](https://github.com/nxp-imx/imx-mkimage/blob/lf-6.18.20_2.0.0/Readme.imx95)
- [CompuLab UCM-iMX95 BSP](https://github.com/compulab-yokneam/meta-bsp-imx95)
