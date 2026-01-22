# imx8mp isp

## Build Host

* Download & sync the ucm-imx8m-plus-sbev Yocto environment

  ```
  mkdir compulab-nxp-bsp && cd compulab-nxp-bsp
  export MACHINE=ucm-imx8m-plus-sbev
  repo init -u https://github.com/nxp-imx/imx-manifest.git -b imx-linux-scarthgap -m imx-6.6.52-2.2.0.xml
  wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx8mp/scarthgap-2.2.0/scripts/meta-bsp-imx8mp.xml
  repo sync
  ```

* Setup build environment

  |NOTE|What SIP to use|
  |---|---|
  ||NXP-ISP for V2+EB-EVCAMRPI<br>BASLER-ISP for V2+EB-EVBSLR|
  ```
  export MACHINE=ucm-imx8m-plus-sbev
  source compulab-setup-env build
  ...
  1) BASLER-ISP
  2) NXP-ISP
  3) NO-ISP
  4) <<
  ISP > 2
  ```

* Issue build
  ```
  bitbake -k imx-image-full
  ```

## [ucm-imx8m-plus-evaluation-kit](https://www.compulab.com/products/som-evaluation-kits/ucm-imx8m-plus-evaluation-kit/)

* ISI Sensors
  * Hardware setup: ucm-imx8m-plus-evaluation-kit-V2 + EB-EVCAMRPI + UC350 (IMX219 sensor)
  * Software setup: csi1-isp0 device tree overlays:
  
   |Interface|Device tree, overlays and bootcmd|
   |---|---|
   |MIPI_CSI1|fw_setenv fdtfile sbev-ucmimx8plus-headless.dtb<br>fw_setenv fdtofile "sbev-ucmimx8plus-lvds.dtbo sbev-ucmimx8plus-csi1-isp0-imx219.dtbo"<br>fw_setenv bootcmd "run bsp_bootcmd"
