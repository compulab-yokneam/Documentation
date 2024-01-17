## Address the emmc2 dma issue

* Reduce the [emmc](https://github.com/compulab-yokneam/linux-compulab/blob/linux-compulab_v6.1.22/arch/arm64/boot/dts/compulab/ucm-imx8m-plus.dtsi#L426-L436) interface speed option;<br>
remove 100mhz and 200mhz pinmux settings:
```
&usdhc3 {
	assigned-clocks = <&clk IMX8MP_CLK_USDHC3>;
	assigned-clock-rates = <400000000>;
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_usdhc3>;
	bus-width = <8>;
	non-removable;
	status = "okay";
};
```
