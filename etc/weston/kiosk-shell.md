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
## Get app_id
```
WAYLAND_DEBUG=1 chromium --no-sandbox --kiosk 2>&1 | | awk '/xdg_shell|wl_shell|set_app_id/'
```
