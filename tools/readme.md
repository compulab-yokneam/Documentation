# Yocto Helper Manual

Supported machines:

* CompuLab SOMs: imx7, imx8

# How to download:
<pre>
wget --output-document=/tmp/yocto-functions.inc https://github.com/compulab-yokneam/Documentation/edit/master/tools/yocto-functions.inc
</pre>

# How to deploy the latest 5 commits to the `meta-bsp-imx8mp`:
<pre>
source /tmp/yocto-functions.inc
suffix=-test YOCTO_LAYER_PATH=${BUILDDIR}/../sources/meta-bsp-imx8mp BASE=HEAD~5 do_yocto_prepare
</pre>

# How to figure out whether the patches reached the target:
|Target|Command Line|
|---|---|
|u-boot-compulab|export target=u-boot-compulab
|linux-compulab|export target=linux-compulab

<pre>
cd ${BUILDDIR}
bitbake-layers show-appends ${target}
</pre>
