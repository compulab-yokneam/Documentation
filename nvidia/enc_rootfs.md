# enc rootfs

## SW to install
* cryptsetup-initramfs
```
apt-get install cryptsetup-initramfs

## Configs to update
```
* ``/etc/cryptsetup-initramfs/conf-hook``
```
cat << eof | tee -a /etc/cryptsetup-initramfs/conf-hook
KEYFILE_PATTERN=/etc/keys/*.key
eof
```

* ``/etc/crypttab``
```
# <target name> <source device>         <key file>      <options>
root UUID=e924612e-56e9-4747-9d4c-e41ca64b8059 /etc/keys/root.key luks,initramfs
```



