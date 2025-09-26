# NXP Wireless SoC AP

Covered devices:
* IW612
* 88W8997

Details about the SoCs are in [RN00104](RN00104.pdf)

## Create Access Point

* Prerequisites:
```
systemctl stop dnsmasq.service
```
|NOTE|NetworkManager runs the the same service on demand.|
|---|---|

* Prepare routing:
```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i uap0 -o eth0 -j ACCEPT
iptables-save > /etc/iptables/iptables.rules
```
|Important|``eth0`` iface has to be replace with the one that the wifi trafic will be forwarded to.
|---|---|

* Enable port forwarding:
```
sed -i 's/^#\(net.ipv[4,6].*forward\)/\1/' /etc/sysctl.conf
```
* Turn on the WiFi radio: 
```
nmcli radio wifi on
```

* In the following example replace \<SSID\> and \<PASSWORD\> with desired access point parameters:
```
nmcli device wifi hotspot ssid <SSID> password <PASSWORD> con-name HotspotCon ifname uap0
```
* Disable wireless AP:
```
nmcli connection down HotspotCon
```

* Enable wireless AP again:
```
nmcli connection up HotspotCon
```
