# How to

## weston.ini 
```
[core]
shell=kiosk-shell.so
idle-time=0
xwayland=true

[output]
name=HDMI-A-1
mode=preferred
app-ids=org.example.YourKioskApp

[output]
name=HDMI-A-2
mode=preferred
app-ids=org.example.AnotherKioskApp

[keyboard]
keymap_layout=us
```

## Run Chromium
```
chromium --no-sandbox --kiosk &>/dev/null &
```

## Get app_id (optional)
```
WAYLAND_DEBUG=1 chromium --no-sandbox --kiosk 2>&1 | | awk '/xdg_shell|wl_shell|set_app_id/'
```

# google resources
* [weston.ini + kiosk-shell](https://www.google.com/search?q=weston+kiosk+shell+example+weston.ini+file)

* [weston.ini + app_id](https://www.google.com/search?q=weston+kiosk+shell+how+to+get+app_id)
