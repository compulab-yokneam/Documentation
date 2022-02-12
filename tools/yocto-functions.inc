unset vendor plat_name YOCTO_TMP YOCTO_KERNEL_RECIPE_FILE YOCTO_UBOOT_RECIPE_FILE suffix

do_export() {
export YOCTO_TMP=${YOCTO_TMP:-/tmp/y}

export vendor=${vendor:-compulab}
export plat_name=${plat_name:-compulab}
export suffix=${suffix:--mod}
export YOCTO_KERNEL_RECIPE=recipes-kernel
export YOCTO_KERNEL_PATCH=${YOCTO_KERNEL_RECIPE}/linux${suffix}/${vendor}/${plat_name}
export YOCTO_KERNEL_INC=${YOCTO_KERNEL_PATCH}".inc"

export YOCTO_UBOOT_RECIPE=recipes-bsp
export YOCTO_UBOOT_PATCH=${YOCTO_UBOOT_RECIPE}/u-boot${suffix}/${vendor}/${plat_name}
export YOCTO_UBOOT_INC=${YOCTO_UBOOT_PATCH}".inc"
}

do_invalid_prepare() {
cat << eof
	Invalid environmen type. Exiting ...
eof
}

do_common_prepare() {
echo "Issue: do_common_prepare(ENV=${ENV_TYPE}, NUM=${NUM}, BASE=${BASE})"
YOCTO_PATCH+=${suffix}
rm -rf ${YOCTO_TMP}/${YOCTO_PATCH}
mkdir -p ${YOCTO_TMP}/${YOCTO_PATCH}
git format-patch --no-numbered ${GNUM} --output-directory ${YOCTO_TMP}/${YOCTO_PATCH} $BASE
pushd .
cd ${YOCTO_TMP}/${YOCTO_PATCH} 
ls | awk -v P=$P 'BEGIN { $0="SRC_URI_append = \" \\" ; print } {$0="\tfile://"$0" \\"; print } END { $0="\""; print } ' | tee ${YOCTO_TMP}/${YOCTO_INC}${EXT}

cat << eof | tee ../${YOCTO_RECIPE_FILE}
FILESEXTRAPATHS_prepend := "\${THISDIR}/${plat_name}${suffix}:"
include ${plat_name}${suffix}.inc
eof

popd
}

do_kernel_prepare() {
# echo "ENV: "${ENV_TYPE}
export YOCTO_RECIPE_FILE=${YOCTO_KERNEL_RECIPE_FILE:-linux-kernel_%.bbappend}
export YOCTO_RECIPE=${YOCTO_KERNEL_RECIPE}
export YOCTO_PATCH=${YOCTO_KERNEL_PATCH}
export YOCTO_INC=${YOCTO_KERNEL_INC}
do_common_prepare
}

do_uboot_prepare() {
# echo "ENV: "${ENV_TYPE}
export YOCTO_RECIPE_FILE=${YOCTO_UBOOT_RECIPE_FILE:-u-boot-compulab_%.bbappend}
export YOCTO_RECIPE=${YOCTO_UBOOT_RECIPE}
export YOCTO_PATCH=${YOCTO_UBOOT_PATCH}
export YOCTO_INC=${YOCTO_UBOOT_INC}
do_common_prepare
}

do_yocto_prepare() {
do_export
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
