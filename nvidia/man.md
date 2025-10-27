# Nvidia man

* --no-flash
```
/path/to/Linux_for_Tegra/tools/kernel_flash/l4t_initrd_flash_internal.sh --no-flash --external-device nvme0n1p1 -c tools/kernel_flash/flash_l4t_t234_nvme.xml -p -c bootloader/generic/cfg/flash_t234_qspi.xml --showlogs --network usb0 edge-ai external
```

* --flash-only
```
/path/to/Linux_for_Tegra/tools/kernel_flash/l4t_initrd_flash_internal.sh --network usb0 --usb-instance 1-6 --device-instance 0 --flash-only --external-device nvme0n1p1 -c "tools/kernel_flash/flash_l4t_t234_nvme.xml" --network usb0 edge-ai external
```
