# NuttX M7 startup and System Manager permissions

The early i.MX95 startup sequence in NuttX was reviewed against the System
Manager configuration used by the UCM-iMX95.

The restart is consistent with an M7 access-control fault, but it does not
appear to be caused by a broad difference between the CompuLab and NXP System
Manager resource policies. The CompuLab `mx95cplrpmsg` configuration follows
the M7 resource allocation from NXP's `mx95evkrpmsg` configuration. CompuLab's
corresponding policy update is available in the
[`mx95cplrpmsg` patch](https://github.com/compulab-yokneam/meta-bsp-imx95/blob/wrynose-6.18.20-2.0.0-devel/recipes-bsp/imx-system-manager/imx-system-manager_2026q1/0008-configs-mx95cplrpmsg.cfg-Apply-all-NXP-restrictions.patch).

The more likely cause is that the application's generated NuttX `.config`
does not retain two settings from the upstream i.MX95 EVK defconfig.

## Relevant startup operations

The NuttX [`__start()`](https://github.com/apache/nuttx/blob/master/arch/arm/src/imx9/imx9_start.c#L227-L243)
sequence performs the following relevant operations:

| Operation | Required access | UCM-iMX95 policy |
| --- | --- | --- |
| `imx9_scmi_initialize()` | MU5 | Granted to the M7 |
| `imx9_clockconfig()` | GPC if the WFI option is enabled | Direct access is not granted |
| `imx9_lowsetup()` | IOMUX, clock and LPUART access | IOMUX and clocks must use SCMI |
| FPU, MPU and TCM setup | M7 private registers | Not controlled by System Manager |

The first likely fault is in
[`imx9_clockconfig()`](https://github.com/apache/nuttx/blob/master/arch/arm/src/imx9/imx9_clockconfig.c#L152-L171).
When `CONFIG_IMX9_WFI_AWAKES_AT_SYSTICK` is enabled, NuttX writes directly to
the M7 GPC control registers. GPC is intentionally owned by System Manager,
so a direct M7 access can produce a TRDC bus fault and an M7 logical-machine
reset.

The second possible fault is in
[`imx9_iomux_configure()`](https://github.com/apache/nuttx/blob/master/arch/arm/src/imx9/imx9_iomuxc.c#L125-L165).
If `CONFIG_IMX9_IOMUX_OVER_SCMI` is disabled, NuttX writes directly to IOMUXC.
IOMUXC is also owned by System Manager and should be configured through SCMI.

The upstream
[`imx95-evk:nsh` defconfig](https://github.com/apache/nuttx/blob/master/boards/arm/imx9/imx95-evk/configs/nsh/defconfig)
explicitly avoids both accesses:

```text
# CONFIG_IMX9_WFI_AWAKES_AT_SYSTICK is not set
CONFIG_IMX9_IOMUX_OVER_SCMI=y
```

This is significant because the generic
[i.MX9 Kconfig](https://github.com/apache/nuttx/blob/master/arch/arm/src/imx9/Kconfig#L35-L76)
defaults to enabling the WFI/GPC operation and disabling IOMUX-over-SCMI. A
custom application configuration that does not preserve the EVK overrides
can therefore fail during `__start()` before the serial console is ready.

## Configuration to verify

Please check the final generated `nuttx/.config`, rather than only the source
defconfig, for the following settings:

```text
CONFIG_IMX9_MU5=y
CONFIG_IMX9_SCMI=y
CONFIG_IMX9_CLK_OVER_SCMI=y
CONFIG_IMX9_IOMUX_OVER_SCMI=y
# CONFIG_IMX9_WFI_AWAKES_AT_SYSTICK is not set

CONFIG_IMX9_LPUART3=y
CONFIG_LPUART3_SERIAL_CONSOLE=y
```

The UCM-iMX95 System Manager configuration already grants the M7 access to
MU5, LPUART3, and the GPIO14/GPIO15 LPUART3 pins. Consequently, the normal
upstream NuttX console startup should not require broader hardware access.

## Confirming the fault

Immediately after reproducing the restart, please run the following command
in the System Manager debug monitor and save its complete output:

```text
err
```

The command displays and clears the recorded errors, so it should be run only
once before the output is captured. According to NXP's
[System Manager configuration-debug documentation](https://github.com/nxp-imx/imx-sm/blob/master/sm/doc/config.md#configuration-debug-configuration_debug):

- an SCMI API permission failure is reported as `SCMI_ERR_DENIED`;
- an unauthorized direct hardware access is reported as a TRDC violation,
  including the faulting address;
- if no access error is recorded, the investigation should move to clock,
  power-domain, address, or MPU configuration.

A GPC address would confirm that
`CONFIG_IMX9_WFI_AWAKES_AT_SYSTICK` is enabled. An IOMUXC address would
confirm that IOMUX-over-SCMI is not active.

Please also provide the NuttX commit ID and the generated `nuttx/.config`.
Together with the `err` output, these will identify the exact failed access.

## Recommended resolution

We do not recommend granting the M7 unrestricted direct access to GPC, CCM,
or IOMUXC. These blocks are centrally managed so that the M7, A55, and M33 do
not program shared hardware inconsistently.

The preferred resolution is to:

1. Base the application configuration on the upstream `imx95-evk:nsh` or
   `imx95-evk:rpmsg` defconfig.
2. Preserve the SCMI and WFI settings listed above.
3. Add only the individual peripherals and pins required by the application
   to the M7 System Manager policy.
4. Disable any exclusively assigned M7 peripheral in the Linux device tree.

If the generated configuration already contains the required settings and
the System Manager monitor still reports a denied resource, the reported
resource and address should be used to make a narrow permission change.
