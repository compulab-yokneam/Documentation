# enc rootfs

## to begin with:

[tpm 1](https://www.google.com/search?q=rootfs+encryption+with+tpm+step+by+step&sca_esv=178916f2631b52eb&sxsrf=ANbL-n5DTJaNijlvtj09Ji6aIT2GHULqvQ%3A1770905997919&ei=jeGNaZzgN8_Di-gPh_yo2Ac&biw=1385&bih=890&oq=rootfs+encryption+with+tpm+ste&gs_lp=Egxnd3Mtd2l6LXNlcnAiHnJvb3RmcyBlbmNyeXB0aW9uIHdpdGggdHBtIHN0ZSoCCAAyBRAhGKABMgUQIRigATIFECEYoAEyBRAhGKABSOIoUL8UWN4fcAF4AZABAJgB6gGgAcUFqgEFMC4zLjG4AQPIAQD4AQGYAgWgAosGwgIKEAAYsAMY1gQYR5gDAIgGAZAGCJIHBTEuMy4xoAeIELIHBTAuMy4xuAfyBcIHBzAuMS4zLjHIBySACAA&sclient=gws-wiz-serp)

[tmp 2](https://www.google.com/search?q=cryptsetup+witj+tpm2&sca_esv=2cf3e72a8cc0c0c9&biw=1385&bih=890&sxsrf=ANbL-n6czi45h33it5yIs3ittP6evooBTg%3A1770906601320&ei=6eONacClE9TLi-gPt860wAU&ved=2ahUKEwjO6braltSSAxVR5AIHHUlXGL8Q0NsOegQIAxAB&uact=5&sclient=gws-wiz-serp&udm=50&fbs=ADc_l-aN0CWEZBOHjofHoaMMDiKp9lEhFAN_4ain3HSNQWw-mMGVXS0bCMe2eDZOQ2MOTwmdSduEdP1lcK-3UDyorIbYrYypmw2ykxY_-AvoMYwpWQvfCGsfTeASDCilOcxNlhUtUK32q2_Zq0ebiRzax6hfaA3Y6mqTbp5yoyrK8YMN_h43PAJWAM8W4jpi6BSwpTYpdopjSWCX6P1Jrocjwh8rrRxBXg&aep=10&ntc=1&mstk=AUtExfAFrZ39K06M8xHffNFcTIjAO9nEXTnTTjnKRnr4Fe9E-SXPTw2Is2KOHBEJwNODcC8PFHj_t4L-DZEBJ9vwsaSkJf9SuguqOlB9rSgZdZ0GId4P0pEPifvl1NEJY34h8UPqJmJ6Ffanq5bFonKUk6tMsn6hOMo5f46VJelgmZnP7KhQ3ZEWI9xRB0O5T6VayraDpa6Z8ia5QnuYOxrH3jsq2bgCJSqcNExxemfF58RxUC-J2NTThNUgEs39ypudzzPV2mHVtzTvnDWG3QoSeyQsN74Meq-t2VCYMD-KNZr1ovxLkDg0OodqD1QNYDbJcaojLoHUKO6yWQ&csuir=1&mtid=heaNaYOFOZKKkdUPmNjNsAg)

[Systemd-cryptenroll](https://wiki.archlinux.org/title/Systemd-cryptenroll)

[NVidia DiskEncryption 35.1](https://docs.nvidia.com/jetson/archives/r35.1/DeveloperGuide/text/SD/Security/DiskEncryption.html)

[NVidia DiskEncryption 36.4.4](https://docs.nvidia.com/jetson/archives/r36.4.4/DeveloperGuide/SD/Security/DiskEncryption.html)

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

* ``/etc/initramfs-tools/hooks/crypttab.sh``
  ```
  cat << eof | tee /etc/initramfs-tools/hooks/crypttab.sh
  #!/bin/sh

  mkdir -p  "${DESTDIR}/cryptroot"
  cp /etc/crypttab "${DESTDIR}/cryptroot/crypttab"
  cp /etc/crypttab "${DESTDIR}/etc/"
    
  mkdir -p  "${DESTDIR}/etc/keys"
  cp /etc/keys/root.key "${DESTDIR}/etc/keys/"
    
  exit 0
  ```

* ``/etc/initramfs-tools/hooks/firmware.sh``
  ```
  cat << eof | tee /etc/initramfs-tools/hooks/firmware.sh
  #!/bin/sh

  ln -fs nvidia/tegra186/xusb.bin ${DESTDIR}/lib/firmware/tegra18x_xusb_firmware
  ln -fs nvidia/tegra194/xusb.bin ${DESTDIR}/lib/firmware/tegra19x_xusb_firmware
  
  exit 0
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
