# i.MX95 HDMI Output Summary

The i.MX95 device trees suggest **external HDMI conversion**, rather than a
native HDMI output from the SoC.

## Primary NXP reference path

The primary display path used by the NXP FRDM reference boards is:

```text
DPU -> LDB/LVDS -> ITE IT6263 bridge -> HDMI Type-A connector
```

Evidence:

- [`imx95-15x15-frdm.dts`](https://github.com/nxp-imx/linux-imx/blob/lf-6.18.20-2.0.0/arch/arm64/boot/dts/freescale/imx95-15x15-frdm.dts) defines an HDMI Type-A connector connected to
  `it6263_out`.
- The same board enables LDB/LVDS channel 1 and connects `lvds1_out` to the
  IT6263 input.
- The IT6263 is declared as an `ite,it6263` bridge on I2C address `0x4c`.
- [`imx95-19x19-frdm-pro.dts`](https://github.com/nxp-imx/linux-imx/blob/lf-6.18.20-2.0.0/arch/arm64/boot/dts/freescale/imx95-19x19-frdm-pro.dts) uses the same IT6263 converter, but connects it
  to LDB/LVDS channel 0.

Relevant files:

- [`arch/arm64/boot/dts/freescale/imx95-15x15-frdm.dts`](https://github.com/nxp-imx/linux-imx/blob/lf-6.18.20-2.0.0/arch/arm64/boot/dts/freescale/imx95-15x15-frdm.dts)
- [`arch/arm64/boot/dts/freescale/imx95-19x19-frdm-pro.dts`](https://github.com/nxp-imx/linux-imx/blob/lf-6.18.20-2.0.0/arch/arm64/boot/dts/freescale/imx95-19x19-frdm-pro.dts)

## Alternative HDMI paths

The device-tree directory also supplies optional MIPI-DSI-to-HDMI overlays:

- MIPI DSI to Analog Devices ADV7535, using four DSI lanes:
  [`imx95-15x15-evk-adv7535.dtso`](https://github.com/nxp-imx/linux-imx/blob/lf-6.18.20-2.0.0/arch/arm64/boot/dts/freescale/imx95-15x15-evk-adv7535.dtso)
- MIPI DSI to Lontium LT9611UXC:
  [`imx95-15x15-evk-lt9611uxc.dtso`](https://github.com/nxp-imx/linux-imx/blob/lf-6.18.20-2.0.0/arch/arm64/boot/dts/freescale/imx95-15x15-evk-lt9611uxc.dtso)

Equivalent overlays are provided for several other i.MX95 reference boards.

## Conclusion

For a UCM-i.MX95 design, the strongest reference-board suggestion is
**LVDS-to-HDMI through an ITE IT6263 bridge**. MIPI-DSI-to-HDMI through an
ADV7535 or LT9611UXC is also supported as an alternative design.

There is no UCM-i.MX95 or CompuLab-specific DTS in this Freescale directory.
The HDMI device trees do not prescribe a fixed output resolution; display
mode selection would normally be based on the monitor's EDID and the limits
of the selected bridge and display pipeline.
