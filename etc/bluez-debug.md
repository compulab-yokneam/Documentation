# Enable debug messages on bluez

* Modify the bluez service file:
```
sed -i 's/\(ExecStart.*bluetoothd\)/\1 -d/g' /lib/systemd/system/bluetooth.service
```

* Reload & Restart the service:
```
systemctl daemon-reload && systemctl restart bluetooth
```

* Follow the service debug messages:
```
journalctl --unit=bluetooth -f
```
