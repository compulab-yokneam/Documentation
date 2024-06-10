#!/bin/bash -x 

git -C ${BUILDDIR}/../sources clone -b kirkstone https://github.com/hailo-ai/meta-hailo.git

cat << eof | tee -a ${BUILDDIR}/conf/local.conf
IMAGE_INSTALL:append = " hailo-firmware libhailort hailortcli hailo-pci libgsthailo "
IMAGE_INSTALL:append = " libgsthailotools tappas-apps hailo-post-processes tappas-tracers "
eof

cat << eof | tee -a ${BUILDDIR}/conf/bblayers.conf
BBLAYERS += "\${BSPDIR}/sources/meta-hailo/meta-hailo-accelerator "
BBLAYERS += "\${BSPDIR}/sources/meta-hailo/meta-hailo-libhailort "
BBLAYERS += "\${BSPDIR}/sources/meta-hailo/meta-hailo-tappas "
eof
