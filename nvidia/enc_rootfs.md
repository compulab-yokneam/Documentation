# enc rootfs

## SW to install
* cryptsetup-initramfs
  ```
  apt-get install cryptsetup-initramfs
  ```

## Configs to update

* ``/etc/cryptsetup-initramfs/conf-hook``
  ```
  cat << eof | tee -a /etc/cryptsetup-initramfs/conf-hook
  KEYFILE_PATTERN=/etc/keys/*.key
  eof
  ```

* ``/etc/crypttab``
  * How to retrieve the data
  ```
  lsblk 
  NAME         MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
  zram0        252:0    0 978.5M  0 disk  [SWAP]
  zram1        252:1    0 978.5M  0 disk  [SWAP]
  zram2        252:2    0 978.5M  0 disk  [SWAP]
  zram3        252:3    0 978.5M  0 disk  [SWAP]
  zram4        252:4    0 978.5M  0 disk  [SWAP]
  zram5        252:5    0 978.5M  0 disk  [SWAP]
  zram6        252:6    0 978.5M  0 disk  [SWAP]
  zram7        252:7    0 978.5M  0 disk  [SWAP]
  nvme0n1      259:0    0 238.5G  0 disk  
  ├─nvme0n1p1  259:1    0   512M  0 part  
  ├─nvme0n1p2  259:2    0   128M  0 part  
  ├─nvme0n1p3  259:3    0   768K  0 part  
  ├─nvme0n1p4  259:4    0  31.6M  0 part  
  ├─nvme0n1p5  259:5    0   128M  0 part  
  ├─nvme0n1p6  259:6    0   768K  0 part  
  ├─nvme0n1p7  259:7    0  31.6M  0 part  
  ├─nvme0n1p8  259:8    0    80M  0 part  
  ├─nvme0n1p9  259:9    0   512K  0 part  
  ├─nvme0n1p10 259:10   0    64M  0 part  /boot/efi
  ├─nvme0n1p11 259:11   0    80M  0 part  
  ├─nvme0n1p12 259:12   0   512K  0 part  
  ├─nvme0n1p13 259:13   0    64M  0 part  
  ├─nvme0n1p14 259:14   0   400M  0 part  
  ├─nvme0n1p15 259:15   0 479.5M  0 part  
  ├─nvme0n1p16 259:16   0   128G  0 part  /
  └─nvme0n1p17 259:17   0    32G  0 part  
    └─root     253:0    0    32G  0 crypt

  blkid /dev/nvme0n1p17
  /dev/nvme0n1p17: UUID="e924612e-56e9-4747-9d4c-e41ca64b8059" TYPE="crypto_LUKS" PARTLABEL="APP_ENC" PARTUUID="f3b04ca0-63a3-460e-82f9-c80bcf32fe9c"
  ```
  * How to upadate the file
  ```
  # <target name> <source device>         <key file>      <options>
  root UUID=e924612e-56e9-4747-9d4c-e41ca64b8059 /etc/keys/root.key luks,initramfs
  ```

* ``<boot-partition>/boot/extlinux/extlinux.conf``
  ```
  APPEND+="cryptdevice=UUID=e924612e-56e9-4747-9d4c-e41ca64b8059:root root=/dev/mapper/root"
  ```
