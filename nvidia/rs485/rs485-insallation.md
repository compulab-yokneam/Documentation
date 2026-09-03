# rs485 standalone driver installation

```bash
sudo -i
source <(wget -q -O - https://raw.githubusercontent.com/compulab-yokneam/Documentation/refs/heads/master/nvidia/rs485/run.me)
```
* After reboot, verify:

```bash
tr '\0' '\n' </proc/device-tree/aliases/serial3
tr '\0' '\n' </proc/device-tree/bus@0/serial@3110000/compatible

sudo modprobe serial_tegra_rs485
dmesg | tail -50
ls -l /dev/ttyTHS3
```

Expected compatible:

```text
nvidia,tegra194-hsuart-rs485
```

Expected device:

```text
/dev/ttyTHS3
```
