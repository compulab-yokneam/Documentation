#!/bin/bash -x

rootdev=$(findmnt / -o SOURCE -n)
bootdev=${rootdev:0:-1}1
umount -l ${bootdev} || true

m=/tmp/${bootdev}

mkdir -p ${m}

mount ${bootdev} ${m} &>/dev/null

for _file in $(ls ${m}/Image*);do
	unlink ${_file}
done

link_target=""
for _image in $(ls /boot/vmlinuz*g*${tail:-""});do
	boot_image_name=$(basename ${_image/vmlinuz/Image})
	cat ${_image} | gunzip -c > ${m}/${boot_image_name}
	link_target=${link_target:-${boot_image_name}}
done
ln -fs ${link_target} ${m}/Image

umount -l ${bootdev} || true

grub-mkconfig -o /boot/grub/grub.cfg || true
