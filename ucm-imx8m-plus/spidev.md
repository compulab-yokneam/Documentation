# SPI bus
UCM-iMX8M-PLUS features three Enhanced Configurable Serial Peripheral Interface (eCSPI) modules.<br>
The CompuLab EVK uses the ECSPI2 bus in order to show the usage of the Linux spidev interface.


The CompuLab demo image with a working spidev can be downloaded from [here](https://drive.google.com/drive/folders/1lFgMzrhqlxho0YJvrBxnLyL5JW_TqixW)


## spidev
* Device Tree:
<pre>
&iomuxc {
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_hog>;
	....
	pinctrl_ecspi2: ecspi2grp {
		fsl,pins = <
			MX8MP_IOMUXC_ECSPI2_SCLK__ECSPI2_SCLK		0x82
			MX8MP_IOMUXC_ECSPI2_MOSI__ECSPI2_MOSI		0x82
			MX8MP_IOMUXC_ECSPI2_MISO__ECSPI2_MISO		0x82
		>;
	};

	pinctrl_ecspi2_cs: ecspi2cs {
		fsl,pins = <
			MX8MP_IOMUXC_ECSPI2_SS0__GPIO5_IO13		0x40000
		>;
	};
	....
};

&ecspi2 {
	#address-cells = <1>;
	#size-cells = <0>;
	fsl,spi-num-chipselects = <1>;
	pinctrl-names = "default";
	pinctrl-0 = <&pinctrl_ecspi2 &pinctrl_ecspi2_cs>;
	cs-gpios = <&gpio5 13 GPIO_ACTIVE_LOW>;
	status = "okay";

	spidev1: spi@0 {
		reg = <0>;
		compatible = "rohm,dh2228fv";
		spi-max-frequency = <500000>;
	};
};
</pre>

* System board setup:<br>Short P21.22(MOSI) and  P21.28(MISO) pins.

* Linux command line test:
<pre>
spidev_test -p 1234/5678 -v -D /dev/spidev1.0

spi mode: 0x4
bits per word: 8
max speed: 500000 Hz (500 kHz)
TX | 31 32 33 34 2F 35 36 37 38 __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __  |1234/5678|
RX | 31 32 33 34 2F 35 36 37 38 __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __  |1234/5678|
</pre>
