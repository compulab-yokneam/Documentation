#!/bin/bash

export sys_time=$(date +%Y%m%d_%H%M%S)
export sys_snap_folder=/tmp/snap/${sys_time}/
export sys_snap_file=/tmp/snap/snap_${sys_time}.tar.bz2
export sys_snap_ext_list=""

_i2c_dump() {
	set -x
	for _bus in $(i2cdetect -l | awk '(!/BPMP/)&&($0=$1)&&(gsub(/i2c-/,""))');do
		i2cdetect -y ${_bus} 2>/dev/null
	done
	i2cdump -f -y 0 0x50
	i2cdump -f -y 7 0x50
	set +x
}

pkg_dump() {
    command -v dpkg || return 0
    dpkg -l >${out_folder}/${FUNCNAME}.out
    sys_snap_ext_list+=" /var/lib/dpkg/info "
}

i2c_dump() {
    _i2c_dump &>${out_folder}/${FUNCNAME}.out
}


net_dump() {
	ls -al /sys/class/net  &>${out_folder}/${FUNCNAME}.out
}

drm_dump() {
	ls -al /sys/class/drm  &>${out_folder}/${FUNCNAME}.out
}

pci_dump() {
	lspci -xk &>${out_folder}/${FUNCNAME}.out
}

dtb_dump() {
    local device_tree_folder="/sys/firmware/devicetree/base"
    sys_snap_ext_list+=" ${device_tree_folder} "
    find ${device_tree_folder} &>${out_folder}/${FUNCNAME}.out
}

_sys_dump() {
	for file in '/home/*/.bash_history /root/.bash_history';do [[ -f ${file} ]] && sys_snap_ext_list+=" ${file} " || true; done
	tar -chjf ${sys_snap_file} /boot /var/log /lib/modules /lib/firmware /etc ${sys_snap_ext_list} ${sys_snap_folder} 2>/dev/null
}

sys_dump() {
    declare -xA commands=()
    commands+=( ['dtb']="dtb_dump" )
    commands+=( ['pci']="pci_dump" )
    commands+=( ['i2c']="i2c_dump" )
    commands+=( ['net']="net_dump" )
    commands+=( ['drm']="drm_dump" )
    commands+=( ['pkg']="pkg_dump" )

    for _com in ${!commands[@]};do
        out_folder=${sys_snap_folder}/${_com}
        mkdir -p ${out_folder}
        echo "Issue ${_com}"
        out_folder=${out_folder} ${commands[${_com}]}
    done
    _sys_dump &
    PID=$!
    sleep 1
    while [ 1 ];do
	[[ -d /proc/${PID} ]] || break
	clear
	ls -al ${sys_snap_file}
	sleep 1
    done
}

sys_dump
cat << eof
    System dump file: ${sys_snap_file}
eof
