# Yocto Helper

Supported machines:

* CompuLab SOMs: imx7, imx8

# How to download:
<pre>
wget --directory-prefix=/tmp/yocto-tools https://github.com/compulab-yokneam/Documentation/edit/master/tools/yocto-helper.sh
</pre>

# How to use the changes with the target BSP meta-layer
* Use [`meta-compulab-csom`](https://github.com/compulab-yokneam/meta-compulab-csom/tree/template) template
<pre>
git -C ${BUILDDIR}/../sources clone --branch template https://github.com/compulab-yokneam/meta-compulab-csom.git
cat << eof | tee -a ${BUILDDIR}/conf/bblayers.conf
BBLAYERS += "\${BSPDIR}/sources/meta-compulab-csom"
eof
</pre>

* Deploy the latest 5 commits to:
<pre>
YOCTO_TARGET_SRC=/path/to/source_code YOCTO_LAYER_PATH=${BUILDDIR}/../sources/meta-compulab-csom BASE=HEAD~5 source /tmp/yocto-tools/yocto-helper.sh
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
