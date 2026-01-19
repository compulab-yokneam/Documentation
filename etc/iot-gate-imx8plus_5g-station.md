# iot-gate-imx8plus 5g station mode

## how to procedure
* Use the alrready installed BalenaOS.
* Make any avaliable router work as a 5G ap.
* Scan available SSID, issue:
```
nmcli -f IN-USE,SSID,BSSID,FREQ,SIGNAL dev wifi
# sample output:
IN-USE  SSID                BSSID              FREQ      SIGNAL
        test-2G-ap      00:CA:CA:FE:CA:DA  2412 MHz  17
        test-5G-ap      00:CA:CA:FE:CA:CA  5220 MHz  17
```
* Creat an WiFi station connection, issue:
```
nmcli device wifi connect test-5G-ap password <YOU_PASSWORD> name wifi_5G_conn
```
* Make it up:
```
nmcli connect up wifi_5G_conn
```
* Make sure the an ip address were assigned to the ``wlan0`` iface:
```
ip -o addr show wlan0
```
* Make sure that the system has only ``wlan0`` entries in the routing table:

|the output must be empty|
|---|

```
netstat -rn | awk '!/wlan0/'
```
* Load the ``wlan0`` interface by:
```
wget https://www.compulab.com/wp-content/uploads/2025/09/iot-gate-imx8plus_debian-linux_2025-09-14.zip
```
