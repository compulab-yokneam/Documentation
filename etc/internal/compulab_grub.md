# CompuLab GRUB how to

CompuLab U-Boot uses distro_bootcmd that scans all available target devices (usb,mmc and emmc) and tries all available boot options.<br>
One then is:
* ```bootefi```
```
load ${dev} ${num} ${loadaddr} EFI/BOOT/bootaa64.efi
load ${dev} ${num} ${fdt_addr} ${fdtfile}
bootefi ${loadaddr} ${fdt_addr}
```

If the target media does not have the ```EFI/BOOT/bootaa64.efi``` file, then ```distro_bootcmd``` continues looking for the kernel image file and the device tree for issuing a booti command w/out any user interactions.

CompuLab Debian and Yocto images do have EFI/BOOT/bootaa64.efi file + all grub configuration files that allow using GRUB boot menu.
