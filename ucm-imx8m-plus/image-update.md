# CompuLab image modification

## Tool & requirements
* Dowbload the [image-update.sh](https://raw.githubusercontent.com/compulab-yokneam/Documentation/master/ucm-imx8m-plus/image-update.sh)
* Requirements:
  the host must have:
  a) qemu-user-static installed
  b) loop device support enabled

## How to
* Expand the image:
```
sudo /path/to/image-update.sh expand <image-file> <size-in-GB>
```

* Image modification using chroot:
```
sudo /path/to/image-update.sh chroot <image-file>
```

* Image modification using chroot and a provided script:
```
sudo /path/to/image-update.sh chroot <image-file> <script-to-issue-in-chroot>
```

|NOTE|This script issues no validation on the image and the script correctness|
|---|---|
