# i.MX952 4 GB LPDDR4X DDR Config Tools Guide

The source PDF, `200b_z11m_non-auto_lpddr4_lpddr4x.pdf`, is sufficient to start a DDR Tool configuration.

Before generating production timing, confirm the exact marking on the installed 4 GB device.
The 4 GB device described in the datasheet is the `MT53D1024M32D4` family.
A possible complete 4266 part number is `MT53D1024M32D4DS-046 WT:D`, but `DS/DT`, speed grade, and revision must match the actual chip.

## DDR Tool settings

Start from the i.MX952 19×19 LPDDR4X 4266 EVK configuration in the current [NXP DDR Tool](https://mcuxpresso.nxp.com/pinsimx/latest/ddr_tool.html), then change the memory topology and board wiring.

| Setting | Value |
|---|---|
| Processor | i.MX952, 19×19 package |
| Memory type | LPDDR4X |
| Target data rate | 4266 MT/s |
| Initial bring-up rate | 3200 MT/s |
| Total package capacity | 32 Gb / 4 GB |
| Package width | x32 |
| Channels | 2 |
| Width per channel | x16 |
| Ranks per channel | 2 |
| Dies per package | 4 |
| Banks per channel/rank | 8 |
| Row bits | 16, `R[15:0]` |
| Column bits | 10, `C[9:0]` |
| Page size | 2048 bytes |
| Burst length | BL16 |
| VDD1 | 1.8 V |
| VDD2 | 1.1 V |
| VDDQ | 0.6 V |
| DBI | Disable initially |
| ECC | Disable during initial validation |
| PHY firmware | FW2024.09-SP2, matching the OEI BSP |

An important density distinction is:

- Total package: 32 Gb
- Each channel across two ranks: 16 Gb
- Each selected rank/channel: 8 Gb

Consequently, use the **8 Gb refresh values**, not the 16 Gb row:

- `tREFI = 3.904 µs`
- `tRFCab = 280 ns`
- `tRFCpb = 140 ns`

At 4266 MT/s:

- `tCK = 468 ps`
- Read latency, DBI disabled: `RL = 36`
- Read latency, DBI enabled: `RL = 40`
- Write latency set A: `WL = 18`
- Write latency set B: `WL = 34`
- `tRCD = max(18 ns, 4 tCK)`
- `tRPpb = max(18 ns, 3 tCK)`
- `tRPab = max(21 ns, 3 tCK)`
- `tRAS = max(42 ns, 3 tCK)`
- `tWR = max(18 ns, 4 tCK)`
- `tWTR = max(10 ns, 8 tCK)`
- `tFAW = 30 ns`

The tool should calculate the encoded controller values from these parameters; do not manually copy controller register values from the 8 GB EVK timing.

## Board information still required

The datasheet cannot provide the UCM-specific:

- DQ bit swapping
- Byte-lane swapping
- CA mapping
- CS, CKE and ODT routing
- Trace lengths
- SoC and DRAM drive strengths
- PMIC rail programming

These must come from the UCM-iMX952 schematic/layout. In particular, do not blindly reuse the PHY mapping from the existing NXP 19×19 LPDDR4X timing file:

```text
/home/val/devel/yocto/wrynose-6.18.20-2.0.0/compulab-imx95-bsp/build-imx952-19x19-lpddr5-evk/workspace/sources/imx-oei/boards/mx952lp4x-19/ddr/MIMX952_LPDDR4X_EVK_19X19_4266MTS_FW2024.09-SP2_timing.c
```

That file identifies only the EVK default device and routing.

## System Manager configuration

The production configuration:

```text
/home/val/devel/yocto/wrynose-6.18.20-2.0.0/compulab-imx95-bsp/build-imx952-19x19-lpddr5-evk/workspace/sources/imx-system-manager/configs/mx952cpl.cfg
```

currently leaves `DDR_CTRL`, `DDR_PHY`, `SRC`, and `SYSCTR_CTL` owned by the System Manager. That is appropriate for normal OEI boot, but the DDR Tool standalone A55 validation application requires a dedicated test System Manager configuration with the DDR-test ownership/access specified by NXP.

Create a separate `mx952cpl-ddr-test.cfg`; do not modify the production configuration. UART1 is already assigned to the AP domain in this configuration, which matches the usual DDR Tool test console arrangement.

## After successful validation

Generate something like:

```text
MIMX952_UCM_LPDDR4X_4GB_4266MTS_FW2024.09-SP2_timing.c
```

It is preferable to add a dedicated OEI board such as `boards/mx952cpl-lp4x` instead of replacing the upstream EVK file.

The Yocto machine configuration will need to change from LPDDR5 to:

```bitbake
OEI_BOARD = "mx952cpl-lp4x"
DDR_TYPE = "lpddr4x"

DDR_FIRMWARE_NAME = " \
    lpddr4x_dmem_v202409.bin \
    lpddr4x_dmem_qb_v202409.bin \
    lpddr4x_imem_v202409.bin \
    lpddr4x_imem_qb_v202409.bin \
"
```

The immediate prerequisites for a production configuration are the exact Kingston/Micron chip marking and the UCM-iMX952 DDR schematic pages. Those are needed to map every Config Tools DQ/CA/IOMUX field and review the generated timing file.

