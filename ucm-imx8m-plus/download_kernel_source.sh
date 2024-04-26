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

	wget -qO - https://github.com/compulab-yokneam/linux-compulab/archive/refs/heads/linux-compulab_v${VERSION}.tar.gz | tar -xvf -
cat << eof
Kernel ${VERSION} folder: $(readlink -f linux-compulab-linux-compulab_v${VERSION})
eof
	pushd linux-compulab-linux-compulab_v${VERSION}
}

get_kernel_source_tree
