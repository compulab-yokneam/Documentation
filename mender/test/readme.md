# Mender Test

## Rootfs switch
* 2 -> 3
  * [Linux command/log](https://github.com/compulab-yokneam/Documentation/blob/master/mender/test/mender_part_02_boot.cap#L2-L30)
    ```
    grub-mender-grubenv-set mender_boot_part 2
    ```
  * [U-Boot boot.scr log](https://github.com/compulab-yokneam/Documentation/blob/master/mender/test/mender_part_02_boot.cap#L115-L163)
    ```
    ## Executing script at 40480000
    + setenv xtrace yes
    + setenv grub_efi EFI/BOOT/bootaa64.efi
    + setenv boot_efi bootefi ${loadaddr} ${fdt_addr_r}
    + setenv grub_env grub-mender-grubenv/mender_grubenv1/env
    + setenv load_efi load ${devtype} ${devnum} ${loadaddr} ${grub_efi}
    + env exist fdt_file
    + setenv fdt_file sb-iotgimx8-ied.dtb
    + setenv load_env0 load ${devtype} ${devnum} ${initrd_addr} ${grub_env} && env import -t ${initrd_addr} ${filesize}
    + setenv load_env1 env exists mender_boot_part || setenv mender_boot_part 2
    + setenv load_env run load_env0; run load_env1
    + setenv load_fdt run load_env; load ${devtype} ${devnum}:${mender_boot_part} ${fdt_addr_r} /boot/${fdt_file}
    + setenv boot_cmd run load_fdt && run load_efi && run boot_efi
    + setenv bootcmd_mmc0 setenv devtype mmc; setenv devnum 0;
    + setenv bootcmd_mmc1 setenv devtype mmc; setenv devnum 1;
    + setenv bootcmd_mmc2 setenv devtype mmc; setenv devnum 2;
    + setenv bootcmd_usb0 setenv devtype usb; setenv devnum 0;
    + env exist iface
    + env exist dev
    + setenv bootdev mmc2
    + test -e mmc2
    + run bootcmd_mmc2
    + setenv devtype mmc
    + setenv devnum 2
    + run boot_cmd
    + run load_fdt
    + run load_env
    + run load_env0
    + load mmc 2 0x43800000 grub-mender-grubenv/mender_grubenv1/env
    1024 bytes read in 1 ms (1000 KiB/s)
    + env import -t 0x43800000 400
    + run load_env1
    + env exists mender_boot_part
    + load mmc 2:2 0x43000000 /boot/sb-iotgimx8-ied.dtb
    58916 bytes read in 3 ms (18.7 MiB/s)
    + run load_efi
    + load mmc 2 0x40480000 EFI/BOOT/bootaa64.efi
    888832 bytes read in 21 ms (40.4 MiB/s)
    + run boot_efi
    + bootefi 0x40480000 0x43000000
    ```
  * [load mmc 2:2 0x43000000 /boot/sb-iotgimx8-ied.dtb](https://github.com/compulab-yokneam/Documentation/blob/master/mender/test/mender_part_02_boot.cap#L148)
    ```diff
    + load mmc 2:2 0x43000000 /boot/sb-iotgimx8-ied.dtb
    ```
* 3 -> 2
  * [Linux command/log](https://github.com/compulab-yokneam/Documentation/blob/master/mender/test/mender_part_03_boot.cap#L2-L30)
    ```
    grub-mender-grubenv-set mender_boot_part 3
    ```
  * [U-Boot boot.scr log](https://github.com/compulab-yokneam/Documentation/blob/master/mender/test/mender_part_03_boot.cap#L115-L163)
    ```
    ## Executing script at 40480000
    + setenv xtrace yes
    + setenv grub_efi EFI/BOOT/bootaa64.efi
    + setenv boot_efi bootefi ${loadaddr} ${fdt_addr_r}
    + setenv grub_env grub-mender-grubenv/mender_grubenv1/env
    + setenv load_efi load ${devtype} ${devnum} ${loadaddr} ${grub_efi}
    + env exist fdt_file
    + setenv fdt_file sb-iotgimx8-ied.dtb
    + setenv load_env0 load ${devtype} ${devnum} ${initrd_addr} ${grub_env} && env import -t ${initrd_addr} ${filesize}
    + setenv load_env1 env exists mender_boot_part || setenv mender_boot_part 2
    + setenv load_env run load_env0; run load_env1
    + setenv load_fdt run load_env; load ${devtype} ${devnum}:${mender_boot_part} ${fdt_addr_r} /boot/${fdt_file}
    + setenv boot_cmd run load_fdt && run load_efi && run boot_efi
    + setenv bootcmd_mmc0 setenv devtype mmc; setenv devnum 0;
    + setenv bootcmd_mmc1 setenv devtype mmc; setenv devnum 1;
    + setenv bootcmd_mmc2 setenv devtype mmc; setenv devnum 2;
    + setenv bootcmd_usb0 setenv devtype usb; setenv devnum 0;
    + env exist iface
    + env exist dev
    + setenv bootdev mmc2
    + test -e mmc2
    + run bootcmd_mmc2
    + setenv devtype mmc
    + setenv devnum 2
    + run boot_cmd
    + run load_fdt
    + run load_env
    + run load_env0
    + load mmc 2 0x43800000 grub-mender-grubenv/mender_grubenv1/env
    1024 bytes read in 2 ms (500 KiB/s)
    + env import -t 0x43800000 400
    + run load_env1
    + env exists mender_boot_part
    + load mmc 2:3 0x43000000 /boot/sb-iotgimx8-ied.dtb
    58916 bytes read in 3 ms (18.7 MiB/s)
    + run load_efi
    + load mmc 2 0x40480000 EFI/BOOT/bootaa64.efi
    888832 bytes read in 20 ms (42.4 MiB/s)
    + run boot_efi
    + bootefi 0x40480000 0x43000000
    ```
  * [load mmc 2:3 0x43000000 /boot/sb-iotgimx8-ied.dtb](https://github.com/compulab-yokneam/Documentation/blob/master/mender/test/mender_part_03_boot.cap#L148)
    ```diff
    + load mmc 2:3 0x43000000 /boot/sb-iotgimx8-ied.dtb
    ```
## Mender OTA
