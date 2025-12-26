# cm-t43 linux how to


## Build machine
* Prepare build environment
  * Downlaod and install cross compiler:
    ```
    wget -O - https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/15.2.0/x86_64-gcc-15.2.0-nolibc-arm-linux-gnueabi.tar.gz | sudo tar -C /opt -xzf -
    ```
  * Set ```CROSS_COMPILE``` and ```ARCH``` environment variables:
    ```
    export CROSS_COMPILE=/opt/gcc-15.2.0-nolibc/arm-linux-gnueabi/bin/arm-linux-gnueabi-
    export ARCH=arm
    ```
* Download linux kernel source"
  ```
  mkdir -p /path/to/cm-t43-bsp/linux && cd /path/to/cm-t43-bsp/linux
  git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git .
  git checkout -b cm-t43-dev-6.12 v6.12
  ```
* Issue build:
  ```  
  make omap2plus_defconfig
  make && make targz-pkg
  ```

## cm-t43
* linux<br>
  Deploy the compiled package:
  ```
  tar --keep-directory-symlink --directory=/ -xf /path/to/linux-6.12.0-arm.tar.gz
  reboot
  ```
* u-boot<br>
  Issue these command for booting the installed kernel package:
  ```
  load mmc 1:2 ${loadaddr} boot/vmlinuz-6.12.0
  load mmc 1:2 ${fdtaddr} boot/dtbs/6.12.0/am437x-sbc-t43.dtb
  setenv emmcroot "/dev/mmcblk1p2 rw"
  run emmcargs
  bootz ${loadaddr} - ${fdtaddr}
  ```
