#!/bin/bash

cp /usr/share/compulab/grub-default /usr/share/compulab/grub-default.orig
sed -i 's/console=tty1//g' /usr/share/compulab/grub-default 
rm -rf /etc/default/grub 
grub-mkconfig -o /boot/grub/grub.cfg
grub-mkconfig -o /boot/grub/grub.cfg
