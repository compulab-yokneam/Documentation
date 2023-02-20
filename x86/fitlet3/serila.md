# Fitlet3

## Serial console 

### Host side

* Device topology

|device|command|
|---|---|
|usb|lsusb --verbose -d 0x0403:0x6014<br>udevadm info /sys/devices/pci0000:00/0000:00:14.0/usb1/1-8|
|uart|udevadm info /dev/ttyUSB0|

* Get tty device configuration:
```
stty -a -F /dev/ttyUSB0
```
```
speed 115200 baud; rows 24; columns 80; line = 0;
intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = <undef>; eol2 = <undef>; swtch = <undef>; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R; werase = ^W; lnext = <undef>; discard = <undef>; min = 1; time = 0;
-parenb -parodd -cmspar cs8 hupcl -cstopb cread clocal -crtscts
-ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl ixon ixoff -iuclc -ixany imaxbel iutf8
opost -olcuc -ocrnl onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0
isig -icanon -iexten -echo echoe echok -echonl -noflsh -xcase -tostop -echoprt echoctl echoke -flusho -extproc

````

* Enable serial terminal on the device serial:

```
systemctl enable serial-getty@ttyUSB0.service
```

* Start serial terminal on the device serial:
```
systemctl start serial-getty@ttyUSB0.service
```

### Client side

Connect the device to a client PC using the serial cable.
Run a terminal application on the PC and get connected to the Fitlet3 device.

|NOTE| it is up to the users to discovery the PC serial port and choose a terminal application.|
| --- | --- |
