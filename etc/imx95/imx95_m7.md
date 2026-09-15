# Cortex-M7 on UCM-iMX95

The Cortex-M7 can run firmware from its internal TCM or from external DDR.
This guide explains how to prepare the i.MX95 firmware, configure the complete
system for the M7, and start or control the M7 from U-Boot and Linux.

> **Platform configuration:** The UCM-iMX95 examples use SoC revision `B0`
> and `LPDDR_TYPE=lpddr5`.

## 1. How to prepare the i.MX95 firmware

### Configure the Yocto firmware selection

The recommended workflow uses the artifacts built and deployed by the
[CompuLab i.MX95 BSP development branch](https://github.com/compulab-yokneam/meta-bsp-imx95/tree/wrynose-6.18.20-2.0.0-devel).

The [BSP RPMsg configuration](https://github.com/compulab-yokneam/meta-bsp-imx95/blob/wrynose-6.18.20-2.0.0-devel/README.md)
provides `mx95cpl` as the default System Manager configuration. To prepare a
system in which Linux can fully control the M7 and communicate over RPMsg, add
these settings to the Yocto build's `conf/local.conf`:

```bitbake
IMXBOOT_VARIANT = "rpmsg"
M4_DEFAULT_IMAGE_MX95:mx95-generic-bsp = "imx95-19x19-evk_m7_TCM_rpmsg_lite_str_echo_rtos.bin"
```

`IMXBOOT_VARIANT = "rpmsg"` selects the `mx95cplrpmsg` System Manager
configuration. The suggested `rpmsg_lite_str_echo_rtos` example runs on the
M7 as an RPMsg string-echo endpoint.

Build the boot container:

```bash
bitbake -k imx-boot
```

The build deploys precompiled M7 `.bin` files under:

```text
${BUILDDIR}/tmp/deploy/images/ucm-imx95/mcore-demos
```

The CompuLab image also installs the `imx-m7-demos` package, which provides
the corresponding ELF files under `/lib/firmware` for Linux `remoteproc`.

### Build flash.bin with imx-boot-tools

The BSP deploys a ready-to-use Makefile and all required artifacts, allowing
`flash.bin` to be rebuilt without rebuilding the complete Yocto image:

```bash
cd <build-directory>/tmp/deploy/images/ucm-imx95/imx-boot-tools
```

The `m7_image.bin` link initially selects the firmware configured by
`M4_DEFAULT_IMAGE_MX95`. To choose another compatible 19x19 TCM application
from the adjacent `mcore-demos` directory, run:

```bash
./m7-set.sh
```

The selected firmware is copied into `imx-boot-tools`, and `m7_image.bin` is
updated to point to it.

#### Build an image that starts M7 automatically

`flash_all` embeds the selected TCM firmware and starts the M7 during system
boot. Run `clean` first to remove outputs left by an earlier invocation:

```bash
make SOC=iMX95 REV=B0 OEI=YES LPDDR_TYPE=lpddr5 clean
make SOC=iMX95 REV=B0 OEI=YES LPDDR_TYPE=lpddr5 flash_all
mv flash.bin flash-ucm-imx95-m7-autostart.bin
```

#### Build an image that leaves M7 under A55 control

`flash_a55` omits the M7 firmware and leaves the M7 under U-Boot or Linux
control:

```bash
make SOC=iMX95 REV=B0 OEI=YES LPDDR_TYPE=lpddr5 flash_a55
mv flash.bin flash-ucm-imx95-a55-controlled-m7.bin
```

When Linux will control the M7, ensure the tools were deployed from an
`imx-boot` build configured with `IMXBOOT_VARIANT = "rpmsg"`. This ensures
that `flash_a55` contains the `mx95cplrpmsg` System Manager firmware.

### Optional: rebuild firmware components (power users only)

Most users should skip this section and use the artifacts already deployed by
BitBake. It is intended only for power users who need to rebuild OEI or System
Manager from source.

#### Obtain the sources with devtool

From the BSP checkout root, initialize a Yocto build directory configured for
the `ucm-imx95` machine, then extract each recipe's source and apply the BSP
patches:

```bash
source sources/openembedded-core/oe-init-build-env <build-directory>
devtool modify imx-oei
devtool modify imx-system-manager
```

The prepared source trees are available at:

```text
${BUILDDIR}/workspace/sources/imx-oei
${BUILDDIR}/workspace/sources/imx-system-manager
```

Run each `devtool modify` command only once in a given workspace. Subsequent
builds use the corresponding workspace source tree automatically.

#### Configure the bare-metal toolchain

```bash
export CROSS_COMPILE=/opt/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-
export SM_CROSS_COMPILE=${CROSS_COMPILE}
export OEI_CROSS_COMPILE=${CROSS_COMPILE}
export TOOLS=/opt/compulab/imx-oei
export ARCH=arm
sudo mkdir -p "${TOOLS}"
sudo ln -sfn "$(dirname "$(dirname "${SM_CROSS_COMPILE}")")" "${TOOLS}/"
```

#### Build OEI

For the LPDDR5 configuration, build both the DDR and TCM OEI images:

```bash
cd "${BUILDDIR}/workspace/sources/imx-oei"
make -j 32 board=mx95lp5 DEBUG=1 DDR_CONFIG=lpddr5_timing \
     r=B0 oei=ddr
make -j 32 board=mx95lp5 DEBUG=1 DDR_CONFIG=lpddr5_timing \
     r=B0 oei=tcm
```

The OEI board, timing configuration, DDR type, and capacity must match the SOM.

#### Build System Manager

Build the default CompuLab configuration:

```bash
cd "${BUILDDIR}/workspace/sources/imx-system-manager"
make -j 32 V=y M=2 config=mx95cpl cfg
make -j 32 V=y M=2 config=mx95cpl
```

For Linux `remoteproc` and RPMsg use, build `mx95cplrpmsg` instead:

```bash
cd "${BUILDDIR}/workspace/sources/imx-system-manager"
make -j 32 V=y M=2 config=mx95cplrpmsg cfg
make -j 32 V=y M=2 config=mx95cplrpmsg
```

Building ATF, OP-TEE, and U-Boot is outside the scope of this guide.

### Prepare an M7 DDR boot container

An M7 application can execute from external DDR when it is too large for the
available TCM/SRAM. The application must be built with its MCUXpresso DDR
linker target and installed as `m7_image.bin`.

Do not use the NXP EVK `flash.bin` unchanged. Generate a new image using
artifacts from the matching CompuLab BSP release:

- CompuLab System Manager configuration
- OEI and DDR timing matching the SOM's DDR type and capacity
- CompuLab U-Boot/SPL
- ATF, OP-TEE, and AHAB firmware
- The M7 application built for DDR

For an [M7-only DDR boot](https://github.com/nxp-imx/imx-mkimage/blob/lf-6.18.20_2.0.0/iMX95/soc.mak#L440),
use:

```text
make SOC=iMX95 REV=B0 OEI=YES LPDDR_TYPE=lpddr5 \
     flash_lpboot_sm_m7_ddr
```

To [boot Linux on the A55 cores together with an M7 application executing from
DDR](https://github.com/nxp-imx/imx-mkimage/blob/lf-6.18.20_2.0.0/iMX95/soc.mak#L453),
use:

```text
make SOC=iMX95 REV=B0 OEI=YES LPDDR_TYPE=lpddr5 \
     flash_all_ddr
```

SD/eMMC stores the boot container. During boot, OEI initializes DDR, the boot
flow copies the M7 firmware into DDR, and System Manager starts the M7. The
application does not execute directly from SD/eMMC.

NXP EVK examples that use only CPU and memory functionality should be readily
portable. Examples using board peripherals may require UCM-iMX95-specific
pinmux, clock, and peripheral configuration.

## 2. How to prepare the entire system for M7

### Connect and monitor the serial consoles

Use 115200 baud, 8 data bits, no parity, one stop bit, and no flow control.

| Core | Debug UART | Connector |
| --- | --- | --- |
| Cortex-A55 (U-Boot/Linux) | LPUART1 | P3 |
| Cortex-M33 (System Manager) | LPUART2 | P19: pin 2 RX, pin 4 TX, pin 8 GND |
| Cortex-M7 | LPUART3 | P20: pin 2 RX, pin 4 TX, pin 8 GND |

Connect the adapter TX signal to the board RX signal and the adapter RX signal
to the board TX signal. Connect GND; do not connect the adapter supply pin.

> **Debugging recommendation:** Connect and monitor all three serial consoles
> simultaneously when debugging M7 functionality. The A55, M33 System Manager,
> and M7 logs provide complementary information needed to follow the complete
> firmware loading and startup sequence.

### Select the M7 startup and ownership model

Choose the boot container and System Manager configuration according to who
must start and control the M7:

| Use case | Boot target | System Manager | Linux device tree |
| --- | --- | --- | --- |
| Start M7 during system boot | `flash_all` | Application-specific | Application-specific |
| Start M7 from U-Boot | `flash_a55` | Application-specific | Application-specific |
| Start M7 from Linux | `flash_a55` | `mx95cplrpmsg` | `ucm-imx95-rpmsg.dtb` |
| Run RPMsg with an auto-started M7 | `flash_all` | `mx95cplrpmsg` | `ucm-imx95-rpmsg.dtb` |

The relevant System Manager access difference is:

| Access direction | `mx95cpl` | `mx95cplrpmsg` |
| --- | --- | --- |
| M33 to M7 and A55 | Full | Full |
| M7 to A55 | Suspend/resume and RPMsg | Suspend/resume and RPMsg |
| A55 to M7 | RPMsg only | Full |

Full A55-to-M7 access in `mx95cplrpmsg` allows Linux `remoteproc` to start and
stop the M7. The RPMsg mode also applies a restricted hardware-resource layout,
so it must be paired with the RPMsg Linux device tree.

### Configure U-Boot for RPMsg with Linux

When the RPMsg M7 example remains active while Linux boots, select the RPMsg
device tree and append the resource-retention arguments without removing
existing options such as `fbcon=nodefer`:

```text
=> setenv fdtfile ucm-imx95-rpmsg.dtb
=> setenv boot_opt "${boot_opt} clk_ignore_unused pd_ignore_unused"
=> saveenv
=> boot
```

Omit `saveenv` when testing the settings for only the current boot.

The `mx95cplrpmsg` System Manager configuration and
`ucm-imx95-rpmsg.dtb` must be used together. The default
`ucm-imx95-som.dtb` does not contain the required M7 memory reservation and
RPMsg resource configuration. For a different M7 application, use a Linux
device tree whose resource ownership matches that application's requirements.

### Verify the Linux DDR reservation

When Linux runs together with the M7, the M7 DDR area must be excluded from
Linux-managed RAM. The CompuLab BSP provides this reservation in
[`arch/arm64/boot/dts/compulab/imx95-rpmsg.dtsi`](https://github.com/compulab-yokneam/linux-compulab/blob/linux-compulab_v6.12.34/arch/arm64/boot/dts/compulab/imx95-rpmsg.dtsi#L7):

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

This reserves 16 MiB at `0x80000000`. The `no-map` property prevents Linux
from using or normally mapping the region.

The definition is included by
[`arch/arm64/boot/dts/compulab/imx95-rpmsg.dtso`](https://github.com/compulab-yokneam/linux-compulab/blob/linux-compulab_v6.12.34/arch/arm64/boot/dts/compulab/imx95-rpmsg.dtso).
The kernel
[Makefile](https://github.com/compulab-yokneam/linux-compulab/blob/linux-compulab_v6.12.34/arch/arm64/boot/dts/compulab/Makefile.ucm-imx95#L10)
composes the final DTB as follows:

```make
ucm-imx95-rpmsg-dtbs := ucm-imx95-som.dtb \
        imx95-rpmsg.dtbo

dtb-$(CONFIG_ARCH_MXC) += ucm-imx95-rpmsg.dtb
```

Therefore, the reservation is present when Linux boots with
`ucm-imx95-rpmsg.dtb`; it is not automatically present in the default
`ucm-imx95-som.dtb`.

If an M7 firmware image and its runtime DDR sections exceed 16 MiB, update
these items together:

- Linux reserved-memory layout
- M7 linker script
- System Manager memory permissions
- Any adjacent RPMsg or audio reserved-memory regions

### Build and deploy the complete system image

After configuring the M7 firmware, System Manager mode, and Linux device tree,
build the complete CompuLab image:

```bash
bitbake -k imx-image-full
```

The resulting compressed disk image is deployed under:

```text
${BUILDDIR}/tmp/deploy/images/ucm-imx95/imx-image-full-ucm-imx95*.wic.zst
```

Write the `.wic.zst` image to the target storage using the normal CompuLab
deployment procedure. When deploying `flash.bin` separately, write it to
SD/eMMC at the 32 KiB offset.

## 3. Examples of using M7

### Start a TCM firmware image from U-Boot

Boot with the `flash_a55` image. Copy a TCM-linked
`imx95-19x19-evk_m7_TCM*.bin` file to the FAT boot partition and stop at the
U-Boot prompt.

If the M7 is already running, stop it first:

```text
=> stopaux 1
```

Prepare the M7, load the firmware, copy it into TCM, and start it:

```text
=> prepaux 1
=> load mmc ${mmcdev}:${mmcpart} ${loadaddr} <m7-firmware>.bin
=> cp.b ${loadaddr} 0x203c0000 ${filesize}
=> dcache flush
=> bootaux 0 1
```

`0x203c0000` is the Cortex-A55-visible M7 TCM boot address. The first `0` in
`bootaux 0 1` is the firmware entry address in the M7 address view, and core
ID `1` selects the M7. The firmware must be linked for M7 TCM and fit within
the 512 KiB TCM window. Its output appears on LPUART3 at P20.

An M7 image embedded by `flash_all` is already running before U-Boot. Use
`flash_a55` when U-Boot must load and start the firmware.

If Linux will boot while this M7 image remains active, append the
resource-retention settings from section 2 and select a device tree whose
resource ownership matches the M7 application before running `boot`.

### Use an auto-started RPMsg example from the Linux CLI

This example assumes:

- `flash_all` embeds and starts
  `imx95-19x19-evk_m7_TCM_rpmsg_lite_str_echo_rtos.bin`
- System Manager uses `mx95cplrpmsg`
- Linux boots with `ucm-imx95-rpmsg.dtb`

After Linux starts, load the RPMsg TTY driver and confirm that the expected
endpoint exists:

```bash
modprobe imx_rpmsg_tty
test -c /dev/ttyRPMSG30 || {
    echo "RPMsg TTY endpoint was not created" >&2
    exit 1
}
```

Send a message to the M7:

```bash
printf '%s\n' "$(date): message from Linux" > /dev/ttyRPMSG30
```

Monitor the kernel log with `dmesg -w` to see the reply. Also monitor the M7
serial console while running the test.

### Start M7 firmware with Linux remoteproc

This example gives Linux control of M7 startup. Use a `flash_a55` container
built with `mx95cplrpmsg` so that the M7 is not started before Linux.

At the U-Boot prompt, prepare the M7 and apply the system settings from
section 2:

```text
=> prepaux 1
=> setenv fdtfile ucm-imx95-rpmsg.dtb
=> setenv boot_opt "${boot_opt} clk_ignore_unused pd_ignore_unused"
=> saveenv
=> boot
```

Linux `remoteproc` loads ELF firmware, not the raw `.bin` file embedded by
`imx-boot`. The `imx-m7-demos` package normally installs the required image.
Verify it is present:

```bash
test -f \
    /lib/firmware/imx95-19x19-evk_m7_TCM_rpmsg_lite_str_echo_rtos.elf
```

Only if the file is missing, copy the matching 19x19 TCM ELF image to the
target:

```bash
install -m 0644 <path-to-rpmsg_lite_str_echo_rtos.elf> \
    /lib/firmware/imx95-19x19-evk_m7_TCM_rpmsg_lite_str_echo_rtos.elf
```

The `remoteprocN` index is not guaranteed. Locate the M7 instance by name
instead of assuming `remoteproc1`:

```bash
RPROC=
for candidate in /sys/class/remoteproc/remoteproc*; do
    test -r "${candidate}/name" || continue
    if [ "$(cat "${candidate}/name")" = "imx-rproc" ]; then
        RPROC="${candidate}"
        break
    fi
done
test -n "${RPROC}" || {
    echo "M7 remoteproc instance was not found" >&2
    exit 1
}
```

Confirm that the M7 is offline, then select and start the firmware:

```bash
cat "${RPROC}/state"
printf '%s' \
    imx95-19x19-evk_m7_TCM_rpmsg_lite_str_echo_rtos.elf \
    > "${RPROC}/firmware"
echo start > "${RPROC}/state"
cat "${RPROC}/state"
```

The final command should report `running`. Load `imx_rpmsg_tty` and use the
string-echo test above.

To stop firmware started by Linux:

```bash
echo stop > "${RPROC}/state"
```

## References

- [MCUXpresso procedure](https://mcuxpresso.nxp.com/mcuxsdk/25.12.00/html/boards/i.MX/imx95lpd5evk19/gettingStarted/topics/run_a_demo_application.html)
- [imx-mkimage i.MX95 targets](https://github.com/nxp-imx/imx-mkimage/blob/lf-6.18.20_2.0.0/Readme.imx95)
- [CompuLab UCM-iMX95 BSP](https://github.com/compulab-yokneam/meta-bsp-imx95/tree/wrynose-6.18.20-2.0.0-devel)
