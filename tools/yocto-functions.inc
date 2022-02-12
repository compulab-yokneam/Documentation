#!/bin/bash


do_init() {
YOCTO_LAYER_PATH=${YOCTO_LAYER_PATH:-/tmp/y}

plat_name=${plat_name:-compulab}
YOCTO_KERNEL_RECIPE=recipes-kernel
YOCTO_KERNEL_PATCH=${YOCTO_KERNEL_RECIPE}/linux${suffix}/${plat_name}
YOCTO_KERNEL_INC=${YOCTO_KERNEL_PATCH}${suffix}".inc"

YOCTO_UBOOT_RECIPE=recipes-bsp
YOCTO_UBOOT_PATCH=${YOCTO_UBOOT_RECIPE}/u-boot${suffix}/${plat_name}
YOCTO_UBOOT_INC=${YOCTO_UBOOT_PATCH}${suffix}".inc"
}

do_invalid_prepare() {
cat << eof
	Invalid environmen type. Exiting ...
eof
}

do_common_prepare() {
echo "Issue: do_common_prepare(ENV=${ENV_TYPE}, NUM=${NUM}, BASE=${BASE})"
YOCTO_PATCH+=${suffix}
rm -rf ${YOCTO_LAYER_PATH}/${YOCTO_PATCH}
mkdir -p ${YOCTO_LAYER_PATH}/${YOCTO_PATCH}
git format-patch --no-numbered ${GNUM} --output-directory ${YOCTO_LAYER_PATH}/${YOCTO_PATCH} $BASE
pushd .
cd ${YOCTO_LAYER_PATH}/${YOCTO_PATCH}
ls | awk -v P=$P 'BEGIN { $0="SRC_URI_append = \" \\" ; print } {$0="\tfile://"$0" \\"; print } END { $0="\""; print } ' | tee ${YOCTO_LAYER_PATH}/${YOCTO_INC}${EXT}

cat << eof | tee ../${YOCTO_RECIPE_FILE}
FILESEXTRAPATHS_prepend := "\${THISDIR}/${plat_name}${suffix}:"
require ${plat_name}${suffix}.inc
eof

popd
}

do_kernel_prepare() {
# echo "ENV: "${ENV_TYPE}
YOCTO_RECIPE_FILE=${YOCTO_KERNEL_RECIPE_FILE:-linux-kernel_%.bbappend}
YOCTO_RECIPE=${YOCTO_KERNEL_RECIPE}
YOCTO_PATCH=${YOCTO_KERNEL_PATCH}
YOCTO_INC=${YOCTO_KERNEL_INC}
do_common_prepare
}

do_uboot_prepare() {
# echo "ENV: "${ENV_TYPE}
YOCTO_RECIPE_FILE=${YOCTO_UBOOT_RECIPE_FILE:-u-boot-compulab_%.bbappend}
YOCTO_RECIPE=${YOCTO_UBOOT_RECIPE}
YOCTO_PATCH=${YOCTO_UBOOT_PATCH}
YOCTO_INC=${YOCTO_UBOOT_INC}
do_common_prepare
}

do_yocto_prepare() {
do_init
if [[ -z ${BASE} ]];then
cat << eof
	No BASE specified. Exiting ...
eof
return
fi

[[ -z ${NUM} ]] && NUM=0
GNUM=" --start-number ${NUM}"
[[ ${NUM} -ne 0 ]] && EXT="."${NUM} || EXT=""

[[ -n ${BIN} ]] && GNUM+=" --full-index --binary"

[[ $ENV_TYPE = "uboot" ||  $ENV_TYPE = "kernel" ]] || ENV_TYPE="invalid"
do_${ENV_TYPE}_prepare
}

do_yocto_prepare
