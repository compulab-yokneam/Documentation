# i.MX95 System Manager and M7 Resource Configuration

The System Manager configuration and the Linux device tree must be treated as
one coordinated resource partition. Changing only one side can result in Linux
driver probe failures, SCMI permission errors, or TRDC access faults.

## Source repositories

- NXP System Manager firmware:
  [nxp-imx/imx-sm](https://github.com/nxp-imx/imx-sm)
- CompuLab Linux kernel:
  [compulab-yokneam/linux-compulab](https://github.com/compulab-yokneam/linux-compulab)
- CompuLab i.MX95 BSP integration:
  [compulab-yokneam/meta-bsp-imx95](https://github.com/compulab-yokneam/meta-bsp-imx95)

## 1. System Manager configuration documentation

For the UCM-iMX95 RPMsg configuration, the relevant System Manager
configuration is `mx95cplrpmsg.cfg`, rather than NXP's generic
`mx95evk.cfg`.

The CompuLab configuration is based on NXP's
[mx95evkrpmsg.cfg](https://github.com/nxp-imx/imx-sm/blob/master/configs/other/mx95evkrpmsg.cfg).
It is added and updated by the following public BSP patches:

- [Add the mx95cplrpmsg configuration](https://github.com/compulab-yokneam/meta-bsp-imx95/blob/wrynose-6.18.20-2.0.0-devel/recipes-bsp/imx-system-manager/imx-system-manager_2026q1/0006-compulab-Add-configs-other-mx95cplrpmsg.cfg.patch)
- [Apply the NXP RPMsg restrictions](https://github.com/compulab-yokneam/meta-bsp-imx95/blob/wrynose-6.18.20-2.0.0-devel/recipes-bsp/imx-system-manager/imx-system-manager_2026q1/0008-configs-mx95cplrpmsg.cfg-Apply-all-NXP-restrictions.patch)

Setting `IMXBOOT_VARIANT = "rpmsg"` selects `mx95cplrpmsg` through the
[CompuLab machine configuration](https://github.com/compulab-yokneam/meta-bsp-imx95/blob/wrynose-6.18.20-2.0.0-devel/conf/machine/compulab-imx95.inc).

NXP provides the following configuration documentation:

- [Getting started and creating a custom configuration](https://github.com/nxp-imx/imx-sm/blob/master/sm/doc/started.md)
- [Configuration file and configtool reference](https://github.com/nxp-imx/imx-sm/blob/master/sm/doc/config.md)
- [System Manager README and documentation build instructions](https://github.com/nxp-imx/imx-sm)
- [System Manager Configuration Tool CLI](https://github.com/nxp-imx/imx-smct)
- [Graphical System Manager Configuration Tool documentation](https://docs.mcuxpresso.nxp.com/pinsimx/26.03/system_manager_configuration_tool.html)

The recommended modification flow is:

1. Create or modify the customer-specific `.cfg` file.
2. Regenerate the `config_*.h` files with `make config=<name> cfg`.
3. Rebuild the System Manager firmware.
4. Rebuild `imx-boot`, because the System Manager image is packaged into the
   boot container.
5. Update the Linux device tree and M7 firmware consistently.
6. Flash the new boot container and deploy the matching DTB.

Within Yocto, permanent changes should be maintained as a patch in the
`imx-system-manager` recipe rather than only editing generated headers or a
temporary devtool workspace.

The current `mx95cplrpmsg.cfg` was also checked with NXP's legacy
`configtool.pl`; it completed successfully and generated all expected
configuration headers.

## 2. Linux peripherals disabled by the RPMsg configuration

With the supplied RPMsg configuration, the disabled Linux devices should
normally remain disabled:

- `sai3` and `micfil` are disabled as native Linux devices because the M7 is
  assigned `SAI3` and `PDM`. Linux accesses the audio path through RPMsg.
- `edma1` and `edma2` are disabled because the System Manager configuration
  assigns both controllers and all their channels to the M7.
- DMA properties are removed from several Linux I2C controllers so that they
  can operate without the DMA engines assigned to the M7.
- Native `lpi2c4` is replaced by an RPMsg I2C bus in the older UCM-specific
  RPMsg DTSI.
- `lpuart5` is assigned to the AP by System Manager, but its Linux node uses
  `edma2`. It may be possible to use it in PIO mode after removing the DMA
  properties, but this requires testing, particularly because it is used by
  the SOM Bluetooth interface.

The relevant CompuLab kernel sources are:

- [UCM-specific RPMsg DTSI](https://github.com/compulab-yokneam/linux-compulab/blob/linux-compulab_v6.18.20/arch/arm64/boot/dts/compulab/ucm-imx95-rpmsg.dtsi)
- [Current common i.MX95 RPMsg DTSI](https://github.com/compulab-yokneam/linux-compulab/blob/linux-compulab_v6.18.20/arch/arm64/boot/dts/compulab/imx95-rpmsg.dtsi)
- [UCM-iMX95 device-tree Makefile](https://github.com/compulab-yokneam/linux-compulab/blob/linux-compulab_v6.18.20/arch/arm64/boot/dts/compulab/Makefile.ucm-imx95)

In the current kernel branch, `ucm-imx95-rpmsg.dtb` is composed from
`ucm-imx95-som.dtb` and `imx95-rpmsg.dtbo`. The latter includes
`imx95-rpmsg.dtsi`. Therefore, changing only `ucm-imx95-rpmsg.dtsi` will not
affect the currently built RPMsg DTB.

If a peripheral is reassigned between Linux and the M7, the following must be
updated together:

- Peripheral, pin, clock, power-domain, DMA and interrupt assignments in the
  System Manager configuration.
- Native Linux node status and DMA properties.
- Any RPMsg proxy node replacing the native Linux driver.
- M7 firmware use of the peripheral.
- Reserved-memory regions when firmware or shared-buffer memory changes.

The configuration tool can permit more than one logical machine to access a
resource. This does not guarantee that two native drivers can safely control
the hardware simultaneously. Software ownership or an explicit hand-off is
still required for non-partitionable resources.

## 3. Hardware and configuration limitations

There is no universal list stating that every particular peripheral can or
cannot be assigned to the M7. Feasibility depends on several constraints:

- The peripheral and its required pads must exist on the selected i.MX95
  package and be routed through the SOM and carrier board.
- Pins cannot be used simultaneously by conflicting mux functions.
- Resources required by System Manager, ELE, DDR initialization, TRDC, SCMI
  transport and the boot process cannot simply be transferred to the M7.
- Some peripherals share clocks, power domains, DMA controllers or TRDC
  regions and cannot always be independently partitioned.
- Linux and the M7 cannot run independent native drivers against the same
  non-partitionable peripheral at the same time.
- M7 DDR and RPMsg memory must be reserved from Linux and must match the
  addresses used by the M7 firmware.
- Board-level multiplexing and the selected SOM configuration options can
  impose additional restrictions.

The [UCM-iMX95 Reference Guide](https://www.compulab.com/wp-content/uploads/2024/10/ucm-imx95_reference-guide_2025-06-08.pdf)
contains the connector routing, peripheral availability and signal
multiplexing information.

For a specific peripheral, feasibility should be checked against all of the
following:

1. Its System Manager macro-resource definition and TRDC granularity.
2. Required clocks, power domains, pins, DMA channels and interrupts.
3. Linux device-tree dependencies.
4. M7 SDK and firmware support.
5. UCM-iMX95 SOM and carrier-board signal routing.
