# Mender on CompuLab iot-gate-imx8mplus devices

|NOTE|iot-gate-imx8plus-r2.1 only|
|---|---|

* Disable an outdated optee patch:
```
cd ${BUILDDIR}
sed -i '$ a BBMASK += "meta-bsp-imx8mp/recipes-security/optee-imx/optee-os_%.bbappend"' ../sources/meta-bsp-imx8mp/conf/machine/iot-gate-imx8plus.conf
```

* Disable extra application install:
```
cd ${BUILDDIR}
sed -i 's/\(^CORE_IMAGE_EXTRA_INSTALL\)/# \1/g' ../sources/meta-bsp-imx8mp/conf/machine/iot-gate-imx8plus.conf
```
