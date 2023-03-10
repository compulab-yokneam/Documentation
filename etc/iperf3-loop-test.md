# iperf3 net-loop test with link speed test

## Prerequisites
1) iperf3
2) iptables legacy: https://wiki.debian.org/iptables
3) ethtool


* Setup routing
```
NET1=eth0
NET2=eth1

ifconfig ${NET1} down
ifconfig ${NET2} down

ifconfig ${NET1} 10.50.0.1/24
ifconfig ${NET2} 10.50.1.1/24

# nat source IP 10.50.0.1 -> 10.60.0.1 when going to 10.60.1.1
iptables -t nat -A POSTROUTING -s 10.50.0.1 -d 10.60.1.1 -j SNAT --to-source 10.60.0.1

# nat inbound 10.60.0.1 -> 10.50.0.1
iptables -t nat -A PREROUTING -d 10.60.0.1 -j DNAT --to-destination 10.50.0.1

# nat source IP 10.50.1.1 -> 10.60.1.1 when going to 10.60.0.1
iptables -t nat -A POSTROUTING -s 10.50.1.1 -d 10.60.0.1 -j SNAT --to-source 10.60.1.1

# nat inbound 10.60.1.1 -> 10.50.1.1
iptables -t nat -A PREROUTING -d 10.60.1.1 -j DNAT --to-destination 10.50.1.1

ip route add 10.60.1.1 dev ${NET1}
arp -i ${NET1} -s 10.60.1.1 $(cat /sys/class/net/${NET2}/address)

ip route add 10.60.0.1 dev ${NET2} 
arp -i ${NET2} -s 10.60.0.1 $(cat /sys/class/net/${NET1}/address) 

```

* server
```
iperf -B 10.50.1.1 -s
```

* client
```
iperf -B 10.50.0.1 -c 10.60.1.1 -t 60 -i 3
```

* Set link speed: 10, 100, 1000
```
ethtool -s ${NET1} autoneg on speed ${speed} duplex full
```
