# Lvds panel support

## panel-simple.c

* NXP driver:<br>https://source.codeaurora.org/external/imx/linux-imx/tree/drivers/gpu/drm/panel/panel-simple.c?h=lf-5.15.y#n1503

* CompuLab lvds panel desciptor: arch/arm64/boot/dts/compulab/ucm-imx8m-plus.dts
<pre>
lvds0_panel {
        compatible = "boe,hv070wsa-100";
        backlight = <&lvds_backlight>;
        enable-gpios = <&pca9555 6 GPIO_ACTIVE_HIGH>;

        port {
                panel_lvds_in: endpoint {
                        remote-endpoint = <&lvds_out>;
                };
        };
};

&ldb {
        status = "okay";
        /*fsl,dual-channel;*/

        lvds-channel@0 {
                fsl,data-mapping = "spwg";
                fsl,data-width = <24>;
                status = "okay";

                port@1 {
                        reg = <1>;

                        lvds_out: endpoint {
                                remote-endpoint = <&panel_lvds_in>;
                        };
                };
        };
};
</pre>

## panel-lvds.c


* NXP driver:<br>https://source.codeaurora.org/external/imx/linux-imx/tree/drivers/gpu/drm/panel/panel-lvds.c?h=lf-5.15.y

* Renesas lvds panel descriptor:<br>https://source.codeaurora.org/external/imx/linux-imx/tree/arch/arm64/boot/dts/renesas/r8a774c0-ek874-idk-2121wr.dts?h=lf-5.15.y
