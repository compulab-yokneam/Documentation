# RS-485 tarball installation

Run as a normal user with `sudo` access. The procedure detects the module SKU
from `/proc/device-tree/compatible` and selects the `nv-super` device tree.

```bash
set -eu

[[ -n ${ARCHIVE:-""} ]] || ARCHIVE=${1:-/path/to/rs485.tar.bz2}
EXTLINUX=/boot/extlinux/extlinux.conf
KVER=$(uname -r)
WORKDIR=$(mktemp -d /tmp/install-485.XXXXXX)
STAMP=$(date +%Y%m%d-%H%M%S)

trap 'rm -rf "$WORKDIR"' EXIT

test "$KVER" = "5.15.148-compulab-tegra" || {
	echo "Unsupported kernel: $KVER"
	exit 1
}

tar -xjf "$ARCHIVE" -C "$WORKDIR"

test -r /proc/device-tree/compatible || {
	echo "Cannot read /proc/device-tree/compatible"
	exit 1
}

COMPAT=$(tr '\0' '\n' </proc/device-tree/compatible)
SKU=$(printf '%s\n' "$COMPAT" |
	sed -n 's/.*p3767-\(000[01345]\).*/\1/p' |
	head -1)

case "$SKU" in
	0000|0001|0003|0004|0005) ;;
	*)
		echo "Unsupported system; compatible strings are:"
		printf '%s\n' "$COMPAT"
		exit 1
		;;
esac

DEFAULT_LABEL=$(awk '
	toupper($1) == "DEFAULT" { print $2; exit }
' "$EXTLINUX")

FLAVOR=nv-super

DTB_NAME="tegra234-p3768-0000+p3767-${SKU}-${FLAVOR}.dtb"
SOURCE_DTB="$WORKDIR/boot/dtbs/$DTB_NAME"
INSTALLED_DTB="/boot/dtb/kernel_${DTB_NAME}"
SOURCE_MODULE="$WORKDIR/lib/modules/$KVER/kernel/drivers/tty/serial/serial-tegra-rs485.ko"
MODULE_DIR="/lib/modules/$KVER/kernel/drivers/tty/serial"

test -f "$SOURCE_DTB" || {
	echo "Required DTB is absent from archive: $DTB_NAME"
	exit 1
}

test -f "$SOURCE_MODULE" || {
	echo "RS-485 module is absent from archive"
	exit 1
}

echo "Detected SKU:    $SKU"
echo "Detected flavor: $FLAVOR"
echo "Selected DTB:    $DTB_NAME"

sudo cp -a "$EXTLINUX" "${EXTLINUX}.backup-${STAMP}"
sudo mkdir -p /boot/dtb "$MODULE_DIR"

if sudo test -e "$INSTALLED_DTB"; then
	sudo cp -a "$INSTALLED_DTB" "${INSTALLED_DTB}.backup-${STAMP}"
fi

sudo install -m 0644 "$SOURCE_DTB" "$INSTALLED_DTB"
sudo install -m 0644 "$SOURCE_MODULE" "$MODULE_DIR/serial-tegra-rs485.ko"
sudo depmod -a "$KVER"

awk -v label="$DEFAULT_LABEL" -v new_fdt="$INSTALLED_DTB" '
	toupper($1) == "LABEL" {
		active = ($2 == label)
	}
	active && toupper($1) == "FDT" {
		next
	}
	{
		print
	}
	active && toupper($1) == "LINUX" {
		match($0, /^[[:space:]]*/)
		print substr($0, 1, RLENGTH) "FDT " new_fdt
		updated = 1
	}
	END {
		if (!updated)
			exit 42
	}
' "$EXTLINUX" >"$WORKDIR/extlinux.conf"

sudo install -m 0644 "$WORKDIR/extlinux.conf" "$EXTLINUX"

echo "Installation complete. Reboot to activate the updated DTB."
```

After reboot, verify:

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
