# Getting started with SDP

* Download files from this [location](https://drive.google.com/drive/folders/1g2P1VUd2WhROOC-E87UMqhHE1f3z_MPe) and uncompress them.

|File|Description|
| :--- | :--- |
|debian-bullseye-arm64-minbase-TIMESTAMP.rw.gpt.sdcard.img.xz|Debian Image (Stable)|
|imx-boot-iot-gate-imx8plus-sd.bin-flash_evk.xz|Bootloader|


* SDP mode:
1) Turn off the device.
2) Connect the device programming-port to the host PC using USBA~microsd cable.
3) Power on the device and issue this command on host PC:
```
uuu -lsusb
```
```
Connected Known USB Devices
        Path     Chip    Pro     Vid     Pid     BcdVersion
        ==================================================
        1:8      MX865   SDPS:   0x1FC9 0x0146   0x0002
```

* Update the device SW using the SDP
1) Update the device bootloader:
```
sudo uuu -v -b emmc /path/to/imx-boot-iot-gate-imx8plus-sd.bin-flash_evk
```
2) Update the device bootloader and OS:
```
sudo uuu -v -b emmc_all /path/to/imx-boot-iot-gate-imx8plus-sd.bin-flash_evk /path/to/debian-bullseye-arm64-minbase.rw.gpt.sdcard.img
```

* Back to the normal:
1) Turn off the device.
2) Disconnect the device programming-port.
3) Turn on the device.
