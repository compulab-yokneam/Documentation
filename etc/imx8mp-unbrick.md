# i.MX8MP Unbricking

## Prerequirements
* Download and install [NXP mfgtools](https://github.com/nxp-imx/mfgtools)
* Download the product firmware:
  * Issue [download firmware according to the device dram options](https://github.com/compulab-yokneam/bin/blob/compulab-firmware/README.adoc#download-firmware-according-to-the-device-dram-options) step only.

* Download and unzip the device live image:
  * Download the live image archive from [here](https://www.compulab.com/wp-content/uploads/2025/09/iot-gate-imx8plus_debian-linux_2025-09-14.zip)
  * Unpack the image:
    ```
    unzip -p /path/to/iot-gate-imx8plus_debian-linux_2025-09-14.zip | dd of=/tmp/iot-gate-imx8plus_debian-linux.img bs=1M status=progress
    ```
## Flashing process

* Issue [prepare flashing setup](https://github.com/compulab-yokneam/bin/blob/compulab-firmware/README.adoc#prepare-flashing-setup) step only.
* As soon as the device was recognezed by the ``mfgtools``, issue this command:
  ```
  sudo uuu -bmap -d -v -b emmc_all /tmp/bootloader/iot-gate-imx8plus/d2d4/flash.bin /tmp/iot-gate-imx8plus_debian-linux.img
  ```
* Wait for a ``100%`` message to show up at the ``uuu`` output and press ``Ctrl^C``
* Issue [after flash verification](https://github.com/compulab-yokneam/bin/blob/compulab-firmware/README.adoc#after-flash-verification)
