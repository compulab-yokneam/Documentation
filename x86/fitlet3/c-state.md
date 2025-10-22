# c-state

* Create an executable ``c-state.sh`` file:
```
cat << eof | tee /opt/c-state.sh
#!/bin/bash -x
echo "C-STATE: Starting updating the c-state ..." > /dev/kmsg
for f in /sys/devices/system/cpu/cpu*/cpuidle/state*/disable; do echo 1 > \$f; done
echo "C-STATE: Updating the c-state [done]" > /dev/kmsg
eof
chmod a+x /opt/c-state.sh

```
* Create an ``/etc/rc.local`` file if not exists:
```
RC_LOCAL=/etc/rc.local
[[ -f ${RC_LOCAL} ]] || (
cat << eof | tee ${RC_LOCAL}
#!/bin/bash

exit 0
eof
)
chmod a+x ${RC_LOCAL}

```
* Update the ``/etc/rc.local`` file:
```
RC_LOCAL=/etc/rc.local
sed -i '/exit/i /opt/c-state.sh' ${RC_LOCAL}

```
* Enable the systemd `rc-local.service``
```
systemctl enable rc-local.service

```

* Reboot the system and make sure that:
1) The syslog contains the evidences of the ``c-state.sh`` script run:
```
dmesg -T | grep "C-STATE"

```
2) the c-states are correct:
```
grep -ira . /sys/devices/system/cpu/cpu*/cpuidle/state*/disable

```
