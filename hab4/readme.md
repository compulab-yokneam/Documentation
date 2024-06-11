# NXP HAB4 on CompuLab SOM

* CompuLab devices are compatible with the NXP HAB4 implementation.<br>
NXP sucure boot covered by [this](https://github.com/nxp-imx/uboot-imx/blob/lf_v2022.04/doc/imx/habv4/guides/mx8m_secure_boot.txt) document.

## CompuLab tools

### [CompuLab CST](https://github.com/compulab-yokneam/cst-tools/tree/master/imx8)

CompuLab CST tool creates:
1) a signed imx-boot image
2) a signed Linux Kernel image
3) a U-boot fuse script for updating the SOC opt fuses

### [CompuLab HAB4 meta-layer](https://github.com/compulab-yokneam/meta-compulab-hab/blob/imx8-kirkstone/README.md)
CompuLab HAB4 meta-layer does all above automatically.

## Warning

| NOTE | otp fuse update is prohibited if the device has hab issue.|
| --- | --- |


| NOTE | otp fusing can turn the device into a brick if the device had a hab issue before fusing. |
| --- | --- |
