## Address the uart dma issue

* option#1) Add imx-sdma firmware:
```
wget -O - --no-check-certificate https://github.com/compulab-yokneam/bin/raw/linux-firmware/imx-sdma-20230404.tar.bz2 | tar -xjvf -
wget -O - --no-check-certificate https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx8mp/kirkstone-2.2.0/recipes-kernel/linux/compulab/5.15.32/imx8mp/linux-firmware-sdma.cfg >> arch/arm64/configs/compulab.config
```

* option#2) Disable dma channels for all enabled uart nodes:
```
&uart3 {
  /delete-property/ dmas;
  /delete-property/ dma-names;
  status = "okay";
};
```
