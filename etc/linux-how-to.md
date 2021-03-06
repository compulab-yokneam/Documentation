# Linux how to

## MuliMedia

* Enable pulseaudio

|**sumo**|**zeus**|
|----|----|
|`systemctl --user enable pulseaudio` | `pulseaudio --system -D` |

## WiFi test

* Stop rfkill
```
rfkill unblock all
```

|Note|Make sure that no other `wpa_supplicant` insstances are running at the same time.<br>Issue: pkill -9 wpa|
|---|---|

* Create a wpa_supplicant.conf

|/etc/wpa_supplicant.conf|
|---|
|ctrl_interface=/run/wpa_supplicant<br>update_config=1|

* Start wpa_supplicant with

```
wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf
```

* Start wpa_cli

```
wpa_cli -i wlan0
```

* Use the scan and scan_results commands to see the available networks:
```
> scan
OK
<3>CTRL-EVENT-SCAN-RESULTS
> scan_results
bssid / frequency / signal level / flags / ssid
04:d4:c4:4f:b9:ac       5785    -54     [WPA2-PSK-CCMP][WPS][ESS]       cl-igord
04:d4:c4:4f:b9:a8       2442    -60     [WPA2-PSK-CCMP][WPS][ESS]       cl-igord
7c:dd:90:05:dd:3e       2462    -53     [WPA2-PSK-CCMP][WPS][ESS][P2P]  TTPN885
a6:cf:12:dd:67:17       2412    -75     [WPA-PSK-CCMP+TKIP][WPA2-PSK-CCMP+TKIP][ESS]    MicroPython-dd6717
7c:dd:90:8a:46:aa       2412    -77     [WPA2-PSK-CCMP][ESS]    Porebrick
58:6d:8f:63:08:94       2432    -83     [WPA-PSK-CCMP+TKIP][WPA2-PSK-CCMP+TKIP][ESS]    compulab-guest 3
b4:75:0e:3e:27:04       2417    -85     [WPA-PSK-CCMP+TKIP][WPA2-PSK-CCMP+TKIP][WPS][ESS]       CISCO1-ENG-2.4
00:23:69:93:3b:6b       5745    -53     [WPS][ESS]      linksys_media
00:23:69:93:3b:6a       2462    -52     [WPS][ESS]      linksys
00:0d:f0:5d:b0:76       2432    -62     [ESS]   pfsense
```

* Add network and save config

```
add_network
0
set_network 0 ssid "CISCO1-ENG-2.4"
set_network 0 psk "clwnen04"
enable_network 0
save_config
```

* Leave the wpa_cli
```
quit
```

* Check the wpa_cli status

```
wpa_cli -i wlan0 status
  bssid=b4:75:0e:3e:27:04
  freq=2417
  ssid=CISCO1-ENG-2.4
  id=0
  mode=station
  pairwise_cipher=CCMP
  group_cipher=TKIP
  key_mgmt=WPA2-PSK
  wpa_state=COMPLETED
  ip_address=192.168.96.30
  p2p_device_address=c2:ee:40:35:e0:a0
  address=c0:ee:40:35:e0:a0
  uuid=cc610a76-418c-5051-99d0-1a861cfe0fa3
```

* Get an ip address:
```
dhclient wlan0
```

* Check the `iw` status

```
iw wlan0 link
Connected to b4:75:0e:3e:27:04 (on wlan0)
        SSID: CISCO1-ENG-2.4
        freq: 2417
        RX: 392667 bytes (846 packets)
        TX: 578 bytes (5 packets)
        signal: -85 dBm
        tx bitrate: 5.5 MBit/s

        bss flags:      short-slot-time
        dtim period:    1
        beacon int:     100
```

## Video Playback
* gplay
```
gplay-1.0 /media/Sintel_DivXPlusHD_2Titles_6500kbps.mkv
```
* Rotate 90
```
        [h]display the operation Help
        [p]Play
        [s]Stop
        [e]Seek
        [a]Pause when playing, play when paused
        [v]Volume
        [m]Switch to mute or not
        [>]Play next file
        [<]Play previous file
        [r]Switch to repeated mode or not
        [u]Select the video track
        [d]Select the audio track
        [b]Select the subtitle track
        [f]Set full screen
        [z]resize the width and height
        [t]Rotate
        [c]Setting play rate
        [i]Display the metadata
        [x]eXit
State changed: buffering
State changed: playing
[Playing (No Repeated)][Vol=1.0][00:00:03/00:15:08]t
Set rotation between 0, 90, 180, 270: 90
```

## EEprom

* U-Boot

|description|command|
|---|---|
|Scan i2c-1 bus|i2c dev 1;i2c probe|
|Dump 1-0x51|i2c md 0x51 .0 0x0 0x100|
|Write to eeprom|i2c mw 0x51 0x40 0xFF 0x10|

* Linux

|description|command|
|---|---|
|Scan i2c-1 bus|i2cdetect -y 1|
|Read from 1-0x51|i2cdump -f -y 1 0x51|
|Write to eeprom|i2ctransfer -f -y 1 w5@0x51 0x40 0xFF=|

## U-Boot environmen

* U-Boot

|description|command|
|---|---|
|Read Current|printenv|
|Apply deafault|env default -a|
|Write|saveenv|

* Linux

|description|command|
|---|---|
|Read Current|fw_pintenv \| tee /var/local/env|
|Clean up environment|echo 0 > /sys/class/block/mmcblk2boot0/force_ro<br>dd if=/dev/zero of=/dev/mmcblk2boot0 bs=1K seek=17 count=1<br>echo 1 > /sys/class/block/mmcblk2boot0/force_ro|
|Write/Restore|cl_setenv --script /var/local/env|
