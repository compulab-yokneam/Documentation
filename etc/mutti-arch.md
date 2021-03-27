# Debian Multiarch


|NOTE|Debian arm64 machine used in this example|
|----|----|


* Get native packages architecture
```
dpkg --print-architecture
arm64
```

* Add foreing architectures
```
dpkg --add-architecture armhf
dpkg --add-architecture armel
apt-get update
```

* Get foreign packages architecture
```
dpkg --print-foreign-architectures
armhf
armel
```

* Install package of foreign architectures:
```
apt-get install libc6:armhf libc6:armel
```

* List of the installed libc6 packages:
```
root@arm64 # dpkg -l libc6
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name           Version      Architecture Description
+++-==============-============-============-=================================
ii  libc6:arm64    2.28-10      arm64        GNU C Library: Shared libraries
ii  libc6:armel    2.28-10      armel        GNU C Library: Shared libraries
ii  libc6:armhf    2.28-10      armhf        GNU C Library: Shared libraries
```
