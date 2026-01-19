# i.MX8MP Unbricking

## Prerequirements

* Download the product firmware:
  * Follow the instructions of this [manual](https://github.com/compulab-yokneam/bin/blob/compulab-firmware/README.adoc)

* Download and unzip the device live image:
  * Download the live image archive from [here](https://www.compulab.com/wp-content/uploads/2025/09/iot-gate-imx8plus_debian-linux_2025-09-14.zip)
  * Unpack the image:
    ```
    unzip -p /path/to/iot-gate-imx8plus_debian-linux_2025-09-14.zip | dd of=/tmp/iot-gate-imx8plus_debian-linux.img bs=1M status=progress
    ```
## Flashing process

* Make the device work in an SDP more; follow the this [manual](https://github.com/compulab-yokneam/bin/blob/compulab-firmware/README.adoc)
* As soon as the device was recognezed by the ``mfgtools``, issue this command:
  ```
  sudo uuu -bmap -d -v -b emmc_all /tmp/bootloader/iot-gate-imx8plus/d2d4/flash.bin /tmp/iot-gate-imx8plus_debian-linux.img
  ```
