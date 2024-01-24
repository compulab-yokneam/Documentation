# Fitlet3

## Watchdog

* Short test scenario:
```
sudo -i
modprobe wdat_wdt
cat /dev/watchdog
echo c > /proc/sysrq-trigger
```
