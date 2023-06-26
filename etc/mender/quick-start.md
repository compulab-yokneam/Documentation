# Mender Quick Start

## imx8mp
```
export MACHINE=iot-gate-imx8plus
mkdir compulab-nxp-bsp && cd compulab-nxp-bsp

repo init -u https://github.com/nxp-imx/imx-manifest.git -b imx-linux-kirkstone -m imx-5.15.71-2.2.0.xml
mkdir -p .repo/local_manifests
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx8mp/kirkstone-2.2.0/scripts/meta-bsp-imx8mp.xml
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/compulab-yokneam/meta-mender-compulab/kirkstone-nxp/scripts/mender-compulab-kirkstone.xml
repo sync

source mender-setup-environment build-${MACHINE}
```

## imx8mm
```
export MACHINE=iot-gate-imx8
mkdir compulab-nxp-bsp && cd compulab-nxp-bsp

repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-kirkstone -m imx-5.15.32-2.0.0.xml
mkdir -p .repo/local_manifests
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx8mm/iot-gate-imx8_r3.2.1/scripts/imx_5.15.32-2.0.0-compulab.xml
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/compulab-yokneam/meta-mender-compulab/kirkstone-nxp/scripts/mender-compulab-kirkstone.xml
repo sync

source mender-setup-environment build-${MACHINE}
```
