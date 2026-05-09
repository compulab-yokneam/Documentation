* env
```
export LIBCAMERA_IPA_MODULE_PATH='/usr/lib/libcamera/ipa-nxp-neo-uguzzi/'
export LIBCAMERA_PIPELINES_MATCH_LIST='nxp/neo,imx8-isi,uvc'
```
* imx219

|Connector|Device Tree|Command to Issue|
|:---|:---|:---|
|SB-UCMIMX95.J4 <-> EB-EVCMPI.J1|fdtfile=ucm-imx95-evk-csi1-imx219.dtb|gst-launch-1.0 --no-position libcamerasrc camera-name=/base/soc/bus@42000000/i2c@426e0000/imx219@10  ! video/x-raw,width=3280,height=2464,format=YUV2 ! clockoverlay ! autovideosink |

* imx477

|Connector|Device Tree|Command to Issue|
|:---|:---|:---|
|SB-UCMIMX95.J4 <-> EB-EVCMPI.J1|fdtfile=ucm-imx95-evk-csi1-imx477.dtb|gst-launch-1.0 --no-position libcamerasrc camera-name=/base/soc/bus@42000000/i2c@426e0000/imx477@1a ! video/x-raw,width=3840,height=2160,format=YUV2 ! clockoverlay ! autovideosink |
