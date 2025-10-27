# Nvidia man

## Workflow 1: How to flash single devices in one step
Steps:
* Make sure you have only ONE device in recovery mode plugged in the host
* Run this command from the Linux_for_Tegra folder:
```
cd /path/to/Linux_for_Tegra
sudo ./tools/kernel_flash/l4t_initrd_flash.sh edge-ai external
```

## Workflow 2: How to generate images first and flash the target later.
Steps:
With device connected (online mode):
* Make sure you have only ONE device in recovery mode plugged in the host
* Run this command from the Linux_for_Tegra folder to generate flash images:
```
sudo /path/to/Linux_for_Tegra/tools/kernel_flash/l4t_initrd_flash_internal.sh --no-flash --external-device nvme0n1p1 -c tools/kernel_flash/flash_l4t_t234_nvme.xml -p -c bootloader/generic/cfg/flash_t234_qspi.xml --showlogs --network usb0 edge-ai external
```

* Put the device in recovery mode again
* Run this command from the Linux_for_Tegra folder:
```
sudo /path/to/Linux_for_Tegra/tools/kernel_flash/l4t_initrd_flash_internal.sh --network usb0 --usb-instance 1-6 --device-instance 0 --flash-only --external-device nvme0n1p1 -c "tools/kernel_flash/flash_l4t_t234_nvme.xml" --network usb0 edge-ai external
```
