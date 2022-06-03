# Airtop3 

## Pulseaudio

### Configuring the outputs

* Rear headphone output
```
pactl load-module module-alsa-sink device=hw:0,0
pacmd update-sink-proplist alsa_output.hw_0_0 device.description="Built-in-Rear"
```

* Front headphone output
```
pactl load-module module-alsa-sink device=hw:0,2
pacmd update-sink-proplist alsa_output.hw_0_2 device.description="Built-in-Front"
```

### Switch between the outputs

* GUI

|output|path|
|---|---|
|front|Profile:Analog Stereo Output;Output:Built-in-Front|
|rear|Profile:Analog Stereo Output;Output:Built-in-Rear|

* CLI

|output|command|
|---|---|
|front|pactl set-default-sink alsa_output.hw_0_2|
|rear|pactl set-default-sink alsa_output.hw_0_0|
