#bin/bash -xv

snap_location=/tmp/sys-snap
snap_time=$(date +%s)

root_mount=$(findmnt -o SOURCE -n /)
boot_mount=${root_mount::-1}1

dir_name=${snap_location}/${snap_time}/
tar_name=${snap_location}-${snap_time}.tar.bz2

mkdir -p ${dir_name}/rootfs/{boot,lib/modules}

mount ${boot_mount} ${dir_name}/rootfs/boot
mount -B /lib/modules/ ${dir_name}/rootfs/lib/modules/

log_name=${dir_name}/snap.log
exec &> >( tee  ${log_name} )

cat /proc/cmdline
uname -a
i2cdetect -l
i2cdump -y -f 1 0x50
enode=/sys/class/mdio_bus/30be0000.ethernet-1/
[[ -e ${enode} ]] && find ${enode}/

cat /proc/mtd 
mtd_debug read /dev/mtd0 0x0 0xc0000 ${dir_name}/u-boot.dump

fw_printenv

tar -C ${snap_location} -cjvf ${tar_name} ${snap_time}

cat << eof

	System snapshot is done
	Please the file: ${tar_name}
	to CompuLab support

eof

umount ${dir_name}/rootfs/boot ${dir_name}/rootfs/lib/modules/
