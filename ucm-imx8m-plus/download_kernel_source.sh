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
	wget -qO - https://github.com/compulab-yokneam/linux-compulab/archive/refs/heads/linux-compulab_v${VERSION}.tar.gz | dd status=progress | tar -xf -
	kernel_folder=$(readlink -f linux-compulab-linux-compulab_v${VERSION})
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

get_kernel_source_tree
