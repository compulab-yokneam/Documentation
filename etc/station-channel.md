# Linux: Set Channel via Terminal (iw) 
To force the AX210 to a specific channel in station mode (managed mode), use the iw command.
Replace wlan0 with your interface name. 
* Check current settings:<br>
  ```iw dev wlan0 info```
* Set to managed mode:<br>
  ```iw dev wlan0 set type managed```
* Connect and set frequency: Use iw to connect to a specific frequency and channel width:
  * Example (5GHz):
    ```iw dev wlan0 connect <SSID> freq 5180 HT40+```
  * Example (6GHz):
    ```iw dev wlan0 connect <SSID> freq 5955 (6GHz often requires WPA3/SAE). ```
