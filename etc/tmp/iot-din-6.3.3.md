# iot-din imx8mp linux-compulab BalenaOS link

* [https://github.com/balena-os/balena-iotdin-imx8p](https://github.com/balena-os/balena-iotdin-imx8p)
	* [https://github.com/compulab-yokneam/meta-bsp-imx8mp/tree/649a638ee1fbfeef62358bdd7bfaf7f6aa72ccbc](https://github.com/compulab-yokneam/meta-bsp-imx8mp/tree/649a638ee1fbfeef62358bdd7bfaf7f6aa72ccbc)
		* [https://github.com/compulab-yokneam/meta-bsp-imx8mp/blob/649a638ee1fbfeef62358bdd7bfaf7f6aa72ccbc/conf/machine/iotdin-imx8p.conf#L27](https://github.com/compulab-yokneam/meta-bsp-imx8mp/blob/649a638ee1fbfeef62358bdd7bfaf7f6aa72ccbc/conf/machine/iotdin-imx8p.conf#L27)
			```
			PREFERRED_VERSION_linux-compulab = "6.6.3"
			```
			* [https://github.com/compulab-yokneam/meta-bsp-imx8mp/blob/649a638ee1fbfeef62358bdd7bfaf7f6aa72ccbc/recipes-kernel/linux/linux-compulab_6.6.3.inc](https://github.com/compulab-yokneam/meta-bsp-imx8mp/blob/649a638ee1fbfeef62358bdd7bfaf7f6aa72ccbc/recipes-kernel/linux/linux-compulab_6.6.3.inc)
				```
				SRCBRANCH = "linux-compulab_v6.6.3"
				SRC_URI = "git://github.com/compulab-yokneam/linux-compulab;protocol=https;branch=${SRCBRANCH}"
				SRCREV = "${AUTOREV}"
				LINUX_VERSION = "6.6.3"
				```
				* [https://github.com/compulab-yokneam/linux-compulab/commits/linux-compulab_v6.6.3](https://github.com/compulab-yokneam/linux-compulab/commits/linux-compulab_v6.6.3)
					```
					bitbake-getvar -r linux-compulab SRCREV
					```
				    * Output
					```
					#
					# $SRCREV [3 operations]
					#   set /home/val/devel/balena/compulab/balena-iotdin-imx8p-dram/build/../layers/poky/meta/conf/bitbake.conf:728
					#     [_defaultval] "INVALID"
					#   set /home/val/devel/balena/compulab/balena-iotdin-imx8p-dram/build/../layers/poky/meta/conf/documentation.conf:398
					#     [doc] "The revision of the source code used to build the package. This variable applies to Subversion, Git, Mercurial and Bazaar only."
					#   set /home/val/devel/balena/compulab/balena-iotdin-imx8p-dram/build/../layers/meta-bsp-imx8mp/recipes-kernel/linux/linux-compulab_6.6.3.inc:3
					#     "${AUTOREV}"
					# pre-expansion value:
					#   "${AUTOREV}"
					SRCREV="AUTOINC"
					```
