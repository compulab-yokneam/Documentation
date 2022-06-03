# Airtop3 

## Pulseaudio

### Configuring the outputs

* Update the default configuration file:
```
cat << eof | sudo tee /etc/pulse/default.pa
load-module module-alsa-sink device=hw:0,0 sink_name=analog-rear sink_properties=device.description=analog-rear
load-module module-alsa-sink device=hw:0,2 sink_name=analog-front sink_properties=device.description=analog-front
# set-default-sink analog-front
eof
```

### Switch between the outputs

|output|GUI|CLI|
|---|---|---|
|front|Profile:Analog Stereo Output;Output:analog-front|pactl set-default-sink analog-front|
|rear|Profile:Analog Stereo Output;Output:analog-rear|pactl set-default-sink analog-rear|

## Used Materials:
* https://wiki.archlinux.org/title/PulseAudio/Examples
* https://www.freedesktop.org/wiki/Software/PulseAudio/Backends/ALSA/Profiles/
