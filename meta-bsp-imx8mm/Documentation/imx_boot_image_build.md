# MCM-IMX8M-MINI imx-boot image build

Supported machine:

* `MCM-IMX8M-MINI`

Define a `MACHINE` environment variable with respect to a required machine:
<pre>
export MACHINE=mcm-imx8m-mini
</pre>


Define these envaronment variables:

|Description|Environment|
|---|---|
|NXP release name|export NXP_RELEASE=rel_imx_5.4.3_2.0.0|
|NXP firmware name|export NXP_FIRMWARE=firmware-imx-8.7.bin|
|CompuLab branch name|export CPL_BRANCH=rel_imx_5.4.3_2.0.0-mcm|


## Prerequisites
It is up to developer to setup arm64 build environment:
* Download a tool chain from [Linaro](https://releases.linaro.org/components/toolchain/binaries/7.4-2019.02/aarch64-linux-gnu/)
* Set environment variables:
<pre>
export ARCH=arm64
export CROSS_COMPILE=/usr/bin/aarch64-linux-gnu-
</pre>
* Create a folder to organize the files:
<pre>
mkdir imx8mm
cd imx8mm
export SRC_ROOT=$(pwd)
</pre>

* Download CompuLab BSP
<pre>
git clone -b ${CPL_BRANCH} https://github.com/compulab-yokneam/meta-bsp-imx8mm.git
export LAYER_DIR=$(pwd)/meta-bsp-imx8mm
</pre>

## Mkimage Setup
* Download the mkimage from:
<pre>
git clone https://source.codeaurora.org/external/imx/imx-mkimage.git
git -C imx-mkimage checkout ${NXP_RELEASE}
</pre>

## Arm Trusted Firmware Setup
Download the ATF from:
<pre>
git clone https://source.codeaurora.org/external/imx/imx-atf.git
git -C imx-atf checkout ${NXP_RELEASE}
git -C imx-atf am ${LAYER_DIR}/recipes-bsp/imx-atf/compulab/imx8mm/*.patch
</pre>
* Make bl31.bin
<pre>
make -C imx-atf PLAT=imx8mm bl31
cp -v imx-atf/build/imx8mm/release/bl31.bin ${SRC_ROOT}/imx-mkimage/iMX8M/
</pre>

## Firmware iMX setup
Download the firmware-imx file from:
<pre>
wget http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/${NXP_FIRMWARE}
bash -x ${NXP_FIRMWARE} --auto-accept
cp -v $(find firmware* | awk '/train|hdmi_imx8|dp_imx8/' ORS=" ") ${SRC_ROOT}/imx-mkimage/iMX8M/
</pre>

## U-Boot
* Download the U-Boot source and apply the CompuLab BSP patches:
<pre>
git clone https://source.codeaurora.org/external/imx/uboot-imx.git
git -C uboot-imx checkout ${NXP_RELEASE}
git -C uboot-imx am ${LAYER_DIR}/recipes-bsp/u-boot/compulab/imx8mm/*.patch
</pre>

* Compile the U-Boot
<pre>
make -C uboot-imx ${MACHINE}_defconfig
make -C uboot-imx
</pre>

* Copy files to the mkimage directory:
<pre>
cp -v $(find uboot-imx | awk '/u-boot-spl.bin$|u-boot.bin$|u-boot-nodtb.bin$|cl-som.*\.dtb$|mkimage$/' ORS=" ") ${SRC_ROOT}/imx-mkimage/iMX8M/                                                                     
</pre>

<!---
## OP-TEE Setup
Download the OP-TEE from:
<pre>
git clone https://source.codeaurora.org/external/imx/imx-optee-os
git -C imx-optee-os checkout ${NXP_RELEASE}
git -C imx-atf am ${LAYER_DIR}/recipes-security/optee-imx/compulab/imx8mm/*.patch
</pre>

* Set environment variables:
<pre>
export ARCH=arm
export CROSS_COMPILE=/usr/bin/arm-linux-gnu-
export CROSS_COMPILE64=/usr/bin/arm-linux-gnu-
</pre>

* Make tee.bin
<pre>
cd imx-optee-os
./scripts/imx_build.sh mx8mmevk
cp -v build.mx8mmevk/core/tee.bin ${SRC_ROOT}/imx-mkimage/iMX8M/
</pre>
-->

## Compiling the **flash.bin** imx-boot image:
* Unset these variables:
<pre>
unset ARCH CROSS_COMPILE
</pre>
* Issue:
<pre>
cd ${SRC_ROOT}/imx-mkimage/iMX8M
sed "s/\(^dtbs = \).*/\1${MACHINE}.dtb/;s/\(mkimage\)_uboot/\1/" soc.mak > Makefile
make clean
make flash_evk SOC=iMX8MM 2>&1 | tee flash_evk.log
make print_fit_hab SOC=iMX8MM 2>&1 | tee print_fit_hab.log
</pre>

## Flashing
`dd if=flash.bin of=/dev/<your device> bs=1K seek=33 status=progress`
