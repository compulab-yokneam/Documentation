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
  * Software setup: csi1-isp0 device tree overlays.<br>
    It is up to the user to choose the method to seting the boot environment:

  |Method|Procedure|
  |---|---|
  |U-Boot|setenv fdtfile sbev-ucmimx8plus-headless.dtb<br>setenv fdtofile 'sbev-ucmimx8plus-lvds.dtbo sbev-ucmimx8plus-csi1-isp0-imx219.dtbo'<br>setenv bootcmd 'run bsp_bootcmd'
  |Linux|fw_setenv fdtfile sbev-ucmimx8plus-headless.dtb<br>fw_setenv fdtofile 'sbev-ucmimx8plus-lvds.dtbo sbev-ucmimx8plus-csi1-isp0-imx219.dtbo'<br>fw_setenv bootcmd 'run bsp_bootcmd'


    ```
    fw_setenv fdtfile sbev-ucmimx8plus-headless.dtb
    fw_setenv fdtofile "sbev-ucmimx8plus-lvds.dtbo sbev-ucmimx8plus-csi1-isp0-imx219.dtbo"
    fw_setenv bootcmd "run bsp_bootcmd"
    reboot
    ```

  * Browse the registered v4l2 devices

    ```
    v4l2-ctl --list-devices
    ():
        /dev/v4l-subdev0
        /dev/v4l-subdev2
        /dev/v4l-subdev3

    (csi0):
        /dev/v4l-subdev1

    FSL Capture Media Device (platform:32c00000.bus:camera):
        /dev/media0

    VIV (platform:viv0):
        /dev/video2

    vsi_v4l2dec (platform:vsi_v4l2dec):
        /dev/video1

    vsi_v4l2enc (platform:vsi_v4l2enc):
        /dev/video0

    viv_media (platform:vvcam-video.0):
        /dev/media1
    ```

  * GST command:
    ```
    gst-launch-1.0 v4l2src device=/dev/video2 ! video/x-raw,width=1280,height=720,format=NV12 ! clockoverlay ! autovideosin
    ```
