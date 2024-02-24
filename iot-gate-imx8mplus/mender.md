# Mender on CompuLab iot-gate-imx8mplus devices

|NOTE|iot-gate-imx8plus-r2.1 only|
|---|---|

* Address an outdated optee patch issue:
```
sed -i '$ a BBMASK += "meta-bsp-imx8mp/recipes-security/optee-imx/optee-os_%.bbappend"' ../sources/meta-bsp-imx8mp/conf/machine/iot-gate-imx8plus.conf
```

* Disable extra application install:
```
sed -i 's/\(^CORE_IMAGE_EXTRA_INSTALL\)/# \1/g' ../sources/meta-bsp-imx8mp/conf/machine/iot-gate-imx8plus.conf
```
