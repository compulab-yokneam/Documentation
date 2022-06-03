# Airtop3 

## Pulseaudio

* Front Headphone output configuration
```
pactl load-module module-alsa-sink device=hw:0,2
pactl set-default-sink alsa_output.hw_0_2
```
