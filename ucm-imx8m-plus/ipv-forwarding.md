# Debian 12

* HotSpot Issue fix:

```
sudo -i
sed -i 's/^#\(net.ipv[4,6].*forward\)/\1/' /etc/sysctl.conf
reboot
```
