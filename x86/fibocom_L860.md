# Linux Modem how to

## Fibocom L860 LTE Module

* Get running kernel version
```
uname -a
```
```
Linux fitlet2-debian 5.4.195 #1 SMP Tue Jun 21 17:20:25 IDT 2022 x86_64 GNU/Linux
```

* Get usb device's list
```
lsusb
```
```
Bus 002 Device 002: ID 0781:5591 SanDisk Corp. Ultra Flair
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 003: ID 8087:095a Intel Corp. MODEM + 2 CDC-ACM + 3 CDC-NCM + SS
Bus 001 Device 002: ID 04b4:6570 Cypress Semiconductor Corp. Unprogrammed CY7C65632/34 hub HX2VL
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

* Get the GSP modem info
```
mmcli -m 0
```
```
  --------------------------------
  General  |                 path: /org/freedesktop/ModemManager1/Modem/0
           |            device id: 9edc77846f293b5b8bf95999021d13acb1186ff4
  --------------------------------
  Hardware |         manufacturer: Fibocom
           |                model: L860 LTE Module
           |    firmware revision: 18600.5001.00.35.01.25
           |            supported: gsm-umts, lte
           |              current: gsm-umts, lte
           |         equipment id: 867921030508518
  --------------------------------
  System   |               device: /sys/devices/pci0000:00/0000:00:15.0/usb1/1-8/1-8.2
           |              drivers: cdc_acm, cdc_ncm
           |               plugin: generic
           |         primary port: ttyACM0
           |                ports: enx000011121314 (net), enx000011121316 (net), 
           |                       enx000011121318 (net), ttyACM0 (at)
  --------------------------------
  Status   |       unlock retries: sim-pin (5), sim-puk (5), sim-pin2 (5), sim-puk2 (5)
           |                state: connected
           |          power state: on
           |          access tech: lte
           |       signal quality: 6% (cached)
  --------------------------------
  Modes    |            supported: allowed: 2g, 3g, 4g; preferred: none
           |              current: allowed: 2g, 3g, 4g; preferred: none
  --------------------------------
  IP       |            supported: ipv4, ipv6, ipv4v6
  --------------------------------
  3GPP     |                 imei: 867921030508518
           |        enabled locks: net-pers
           |          operator id: 42503
           |        operator name: Rami Levy
           |         registration: home
  --------------------------------
  3GPP EPS | ue mode of operation: csps-2
  --------------------------------
  SIM      |     primary sim path: /org/freedesktop/ModemManager1/SIM/0
  --------------------------------
  Bearer   |                paths: /org/freedesktop/ModemManager1/Bearer/0
```

* Add a cellular connection
```
nmcli connection add type gsm ifname ttyACM0 con-name CellularCon apn ISP-APN
```

* Get NetworkManager's connection list
```
nmcli
```
```
ttyACM0: connected to CellularCon
        "Intel Celeron N3350/Pentium N4200/Atom E3900 xHCI"
        gsm (cdc_acm, cdc_ncm), hw, iface ppp0, mtu 1500
        ip4 default
        inet4 10.67.255.76/32
        route4 10.67.255.76/32 metric 700
        route4 default via 10.67.255.76 metric 700

ppp0: disconnected
        "ppp0"
        ppp, sw, mtu 1500

eno1: unavailable
        "Intel I211"
        ethernet (igb), 00:01:C0:12:34:57, hw, mtu 1500

enp1s0: unavailable
        "Intel I211"
        ethernet (igb), 00:01:C0:12:34:56, hw, mtu 1500

lo: unmanaged
        "lo"
        loopback (unknown), 00:00:00:00:00:00, sw, mtu 65536

Use "nmcli device show" to get complete information about known devices and
"nmcli connection show" to get an overview on active connection profiles.

Consult nmcli(1) and nmcli-examples(7) manual pages for complete usage details.
```
