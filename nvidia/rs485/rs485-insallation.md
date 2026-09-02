# RS-485 tarball installation

```bash
sudo -i
source <(curl -L https://raw.githubusercontent.com/compulab-yokneam/Documentation/refs/heads/master/nvidia/rs485/run.me)
```
* After reboot, verify:

```bash
tr '\0' '\n' </proc/device-tree/aliases/serial3
tr '\0' '\n' </proc/device-tree/bus@0/serial@3110000/compatible

sudo modprobe serial_tegra_rs485
dmesg | tail -50
ls -l /dev/ttyTHSRS4853
```

Expected compatible:

```text
nvidia,tegra194-hsuart-rs485
```

Expected device:

```text
/dev/ttyTHSRS4853
```
