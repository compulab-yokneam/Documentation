# CompuLab imx8mp Linux enable logs

```
sed -i 's/\(^.*\/var\/log\)/# \1/g' /etc/fstab
umount /var/log -l 2>/dev/null || true
mkdir -p /var/log/journal
systemd-tmpfiles --create --prefix /var/log/journal
```
