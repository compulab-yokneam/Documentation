# CompuLab image modification

## Tool & requirements
* Dowbload the [image-update.sh](https://github.com/compulab-yokneam/Documentation/blob/master/ucm-imx8m-plus/image-update.sh)
* Requirements:
  the host must have:<br>
  a) qemu-user-static installed<br>
  b) loop device support enabled<br>

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

|NOTE|This tool issues no validation on the image and the script correctness|
|---|---|
