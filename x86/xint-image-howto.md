# XINT image create how to

## Input

|file name/device node|description|
|---|---|
|/dev/sdh|Original media|
|xint.img|Image file|
|/dev/loop29|Igage loop device|

## Create an 3G-image file:
|NOTE|3G-file is enought; the original device data resides below 3G capacity|
|---|---|
```
sudo dd if=/dev/sdh of=xint.img bs=1M count=3084 status=progress
```

## Create a loop device for accessing the image data:
```
sudo losetup --show --find xint.img
```

## Replicate the GPT partition scheme from /dev/sdh to /dev/loop29
```
sudo sgdisk -R /dev/loop29 /dev/sdh
```

## Inform the OS of partition table changes
```
sudo partprobe /dev/loop29
```

## Original media
* blkid
```
sudo blkid /dev/sdh*
```
<pre>
/dev/sdh: PTUUID="cf34e71b-4402-4599-8428-101ddd4879d1" PTTYPE="gpt"
/dev/sdh1: UUID="ED1B-C4FD" TYPE="vfat" PARTLABEL="EFI_RECOVERY" PARTUUID="6fdf2915-727d-4d5c-892c-5801a925fdc0"
/dev/sdh2: UUID="c79651a3-07de-448f-a730-479923bb11ae" TYPE="ext4" PARTLABEL="RECOVERY" PARTUUID="d6d9ce8c-b3d3-482e-88ea-fc901629f240"
</pre>

* partition schem
```
sudo sgdisk -p /dev/sdh
```
<pre>
Disk /dev/sdh: 250069680 sectors, 119.2 GiB
Model: D
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): CF34E71B-4402-4599-8428-101DDD4879D1
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 250069646
Partitions will be aligned on 2048-sector boundaries
Total free space is 244798061 sectors (116.7 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          524287   255.0 MiB   EF00  EFI_RECOVERY
   2          524288         5273599   2.3 GiB     8300  RECOVERY
</pre>

## Image file loop device
* blkid
```
sudo blkid /dev/loop29*
```
<pre>
/dev/loop29: PTUUID="cf34e71b-4402-4599-8428-101ddd4879d1" PTTYPE="gpt"
/dev/loop29p1: UUID="ED1B-C4FD" TYPE="vfat" PARTLABEL="EFI_RECOVERY" PARTUUID="6fdf2915-727d-4d5c-892c-5801a925fdc0"
/dev/loop29p2: UUID="c79651a3-07de-448f-a730-479923bb11ae" TYPE="ext4" PARTLABEL="RECOVERY" PARTUUID="d6d9ce8c-b3d3-482e-88ea-fc901629f240"
</pre>

* partition schem
```
sudo sgdisk -p /dev/loop29
```
<pre>
Disk /dev/loop29: 6316032 sectors, 3.0 GiB
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): CF34E71B-4402-4599-8428-101DDD4879D1
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 6315998
Partitions will be aligned on 2048-sector boundaries
Total free space is 1044413 sectors (510.0 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          524287   255.0 MiB   EF00  EFI_RECOVERY
   2          524288         5273599   2.3 GiB     8300  RECOVERY
</pre>
