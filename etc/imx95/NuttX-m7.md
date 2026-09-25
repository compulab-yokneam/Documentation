# Loading NuttX M7 firmware from DDR on UCM-iMX95

## Overview

NuttX M7 firmware can be loaded from DDR on UCM-iMX95 using either U-Boot or
Linux remoteproc. Two firmware layouts are supported:

1. Link NuttX at `0x80000000` and use the existing CompuLab M7 firmware
   carveout.
2. Keep the upstream NuttX link address at `0x90000000` and add a dedicated
   4 MiB firmware carveout and System Manager permission.

The RPMsg vrings, shared buffers, and resource table use separate reserved
memory regions. They do not need to reside inside the firmware-code carveout.

## RPMsg shared-memory layout

The upstream NuttX RPMsg addresses already match the CompuLab BSP:

| Purpose | Address range |
| --- | ---: |
| RPMsg vring 0 | `0x88000000-0x88007fff` |
| RPMsg vring 1 | `0x88008000-0x8800ffff` |
| Second RPMsg vdev rings | `0x88010000-0x8801ffff` |
| RPMsg buffer pool | `0x88020000-0x8811ffff` |
| Resource table | `0x88220000-0x88220fff` |

NuttX defines the vring base as `0x88000000` and copies its resource table to
`0x88220000` at runtime. Keep these addresses unchanged for both solutions.

## Solution 1: Link NuttX at `0x80000000`

This solution uses the existing 16 MiB M7 firmware reservation and the current
`mx95cplrpmsg` System Manager permissions. It requires a UCM-iMX95-specific
copy of the NuttX DDR linker script.

### NuttX linker script

Change the firmware DDR region to `0x80000000`:

```ld
MEMORY
{
  m_interrupts (rx) : ORIGIN = 0x80000000, LENGTH = 0x00000800
  flash        (rx) : ORIGIN = 0x80000800, LENGTH = 0x003ff800
  sram         (rwx): ORIGIN = 0x20000000, LENGTH = 256K
  ocram        (rwx): ORIGIN = 0x20480000, LENGTH = 352K
}
```

The resulting firmware occupies `0x80000000-0x803fffff`, which fits inside
the existing reservation:

```dts
m7_reserved: m7@80000000 {
	no-map;
	reg = <0 0x80000000 0 0x01000000>;
};
```

### Linux device tree

The firmware reservation must be included in the `cm7` `memory-region` list so
that Linux remoteproc can map and load the ELF segments:

```dts
&cm7 {
	memory-region = <&vdevbuffer>,
			<&vdev0vring0>, <&vdev0vring1>,
			<&vdev1vring0>, <&vdev1vring1>,
			<&rsc_table>, <&m7_reserved>;
};
```

No System Manager permission change is required. The existing M7 executable
DDR window covers `0x80000000-0x89ffffff`.

## Solution 2: Keep the upstream NuttX address at `0x90000000`

The upstream NuttX linker script assigns exactly 4 MiB to the DDR firmware:

```ld
m_interrupts (rx) : ORIGIN = 0x90000000, LENGTH = 0x00000800
flash        (rx) : ORIGIN = 0x90000800, LENGTH = 0x003ff800
```

The complete firmware range is therefore
`0x90000000-0x903fffff`. U-Boot's UCM-iMX95 Linux kernel load address is
`0x90400000`, immediately after the NuttX region.

### Linux device tree

Add a separate 4 MiB reservation under `reserved-memory` in
`imx95-rpmsg.dtsi`:

```dts
m7_nuttx_reserved: m7-nuttx@90000000 {
	no-map;
	reg = <0 0x90000000 0 0x00400000>;
};
```

Add the new reservation to the `cm7` memory list:

```dts
&cm7 {
	memory-region = <&vdevbuffer>,
			<&vdev0vring0>, <&vdev0vring1>,
			<&vdev1vring0>, <&vdev1vring1>,
			<&rsc_table>, <&m7_nuttx_reserved>;
};
```

The original `m7_reserved` node at `0x80000000` can remain reserved for
compatibility with CompuLab/NXP firmware. If Linux remoteproc must load both
layouts, include both firmware carveouts:

```dts
&cm7 {
	memory-region = <&vdevbuffer>,
			<&vdev0vring0>, <&vdev0vring1>,
			<&vdev1vring0>, <&vdev1vring1>,
			<&rsc_table>,
			<&m7_reserved>, <&m7_nuttx_reserved>;
};
```

Do not create one continuous reservation from `0x80000000` through
`0x903fffff`. Such a reservation would consume approximately 260 MiB and
overlap the RPMsg shared-memory carveouts around `0x88000000`.

### System Manager configuration

The standard M7 executable DDR permission ends at `0x89ffffff`. Add a separate
permission for the NuttX firmware to the M7 logical-machine memory section of
the `mx95cplrpmsg` configuration:

```text
DDR                 EXEC, begin=0x090000000, end=0x0903FFFFF
```

Rebuild System Manager, repack `flash.bin`, install it, and reboot the board so
the new permission is active.

No Linux remoteproc driver change is required. The i.MX95 remoteproc address
translation table already covers `0x90000000`, and the driver obtains the M7
boot address from the ELF `.interrupts` section.

## Starting NuttX from U-Boot

Use the `mx95cplrpmsg` System Manager configuration and boot Linux with the
RPMsg-enabled device tree.

For firmware linked at `0x80000000`:

```text
=> prepaux 1
=> load mmc ${mmcdev}:${mmcpart} 0x80000000 nuttx.bin
=> dcache flush
=> bootaux 0x80000000 1
```

For firmware linked at `0x90000000`:

```text
=> prepaux 1
=> load mmc ${mmcdev}:${mmcpart} 0x90000000 nuttx.bin
=> dcache flush
=> bootaux 0x90000000 1
```

When U-Boot starts the M7, Linux should attach to the already-running remote
processor. Linux must not attempt to load and start a second firmware image.

## Starting NuttX with Linux remoteproc

1. Use a `flash_a55` container containing the `mx95cplrpmsg` System Manager.
2. Leave the M7 offline while Linux boots.
3. Boot with `ucm-imx95-rpmsg.dtb` containing the appropriate firmware
   carveout in the `cm7` `memory-region` list.
4. Install the NuttX ELF under `/lib/firmware`.
5. Select the ELF through the remoteproc sysfs interface and start the M7.

Linux remoteproc requires the ELF file rather than the raw `.bin` image used by
U-Boot.

## Firmware verification

Inspect the NuttX ELF before deployment:

```bash
arm-none-eabi-readelf -h -l -S nuttx
```

Verify that:

- `.interrupts` and its corresponding `PT_LOAD` segment begin at
  `0x80000000` for Solution 1 or `0x90000000` for Solution 2;
- all DDR `PT_LOAD` segments fit inside the selected firmware carveout;
- the ELF contains a `.resource_table` section;
- the RPMsg vring and resource-table addresses remain `0x88000000` and
  `0x88220000`, respectively.

## Choosing a solution

Solution 1 requires only a NuttX linker-script adjustment and a Linux
device-tree mapping correction. It is the smallest BSP change and uses the
existing System Manager permissions.

Solution 2 preserves the upstream NuttX DDR layout. It requires a new Linux
reserved-memory carveout, a matching System Manager M7 permission, and an
updated `flash.bin`.
