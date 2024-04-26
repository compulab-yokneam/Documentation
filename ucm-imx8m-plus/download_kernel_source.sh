#!/bin/bash -x

function get_kernel_source_tree() {

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
cat << eof
	Extracting kernell ${VERSION} -> $(pwd)/linux-compulab-linux-compulab_v${VERSION}
eof
	wget -qO - https://github.com/compulab-yokneam/linux-compulab/archive/refs/heads/linux-compulab_v${VERSION}.tar.gz | tar -xf -
	kerne_folder=$(readlink -f linux-compulab-linux-compulab_v${VERSION})
cat << eof
How to continue witt Linux Kernel ${VERSION}:
cd ${kernel_folder}
make compulab_v8_defconfig compulab.config
# Build kernel, modules and dtbs
make -j `nproc`
# Build only the binary kernel deb package 
make -j `nproc` bindeb-pkg
# Build the kernel as a bzip2 compressed tarball
make -j `nproc` bindeb-pkg
eof
}

get_kernel_source_tree
