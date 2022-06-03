# Airtop3 

## Pulseaudio

NOTE: This is not a permanet configuration; must be issued after each pulseaudio restart.<br>
A persistent config solution will be provided latter.

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

It can be carried out either by GUI or CLI:

|output|GUI|CLI|
|---|---|---|
|front|Profile:Analog Stereo Output;Output:Built-in-Front|pactl set-default-sink alsa_output.hw_0_2|
|rear|Profile:Analog Stereo Output;Output:Built-in-Rear|pactl set-default-sink alsa_output.hw_0_0|
