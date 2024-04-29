#!/bin/bash -x

PROJECT_NAME=linux-compulab
SRC_URI=https://github.com/compulab-yokneam/${PROJECT_NAME}/archive/refs/heads/

function get_kernel_source_vers() {

	select_string+="5.15.32 "
	select_string+="5.15.71 "
	select_string+="6.1.22 "
	select_string+="6.1.55 "
	select_string+="6.6.3 "
	select_string+="<< "

	PS3="(?): "
	select i in $select_string
	do
	case $i in
		"<<")
		return
		;;
		*)
		export VERSION=${i}
		break
		;;
		esac
	done
}

function get_kernel_source_tree() {
	kernel_folder=$(pwd)/${PROJECT_NAME}_v${VERSION}
	mkdir -p ${kernel_folder}
cat << eof
	Extracting kernel ${VERSION} -> ${kernel_folder}
eof
	wget -qO - ${SRC_URI}/${PROJECT_NAME}_v${VERSION}.tar.gz | dd status=progress | tar -C ${kernel_folder} --strip-components=1 --extract --gzip --file -
cat << eof
Done!

How to continue:
  make -C ${kernel_folder} compulab_v8_defconfig compulab.config
  # Choose a packaging method:
  deb) make -C ${kernel_folder} -j 16 bindeb-pkg
  tar) make -C ${kernel_folder} -j 16 tarbz2-pkg

Good Luck!
eof
}

get_kernel_source_vers
get_kernel_source_tree
