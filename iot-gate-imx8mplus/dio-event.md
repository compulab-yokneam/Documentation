# DIO event grab sample setup

# How to enable

|NOTE|Works with bsp_bootcmd only|
|---|---|

```
fw_setenv fdtofile iot-gate-imx8plus-gpio-keys.dtbo
```
* The source of:
  * [device tree](https://github.com/compulab-yokneam/linux-compulab/blob/linux-compulab_v6.1.22/arch/arm64/boot/dts/compulab/iot-gate-imx8plus-gpio-keys.dts)
  * [Makefile](https://github.com/compulab-yokneam/linux-compulab/blob/linux-compulab_v6.1.22/arch/arm64/boot/dts/compulab/Makefile#L33)

# How to connect
* Connect Lab Power Supply as below:
  * PS(+) to IOT-GATE-IMX8PLUS P8-19
  * PS(-) to IOT-GATE-IMX8PLUS P8-22
* Use male-to-male wire jumpers to interconnect:
  * OUT2 (P8-18) with IN3 (P8-13)

```
---------------------
| IOT-GATE-IMX8PLUS |                        --------------
|             ------|                        |            |
|             |     |-*-(19)---< <-----(+)-*-|Power Supply|
| ----------  |     |-*-(22)---< <-----(-)-*-|  12V-24V   |
| |IE-DI4O4|==|     |-*-(18)---,             |            |
| ----------  | P8  |          |             --------------
|   Slot D    |     |-*-(13)---'
|             |     |
|             |     |
|             |     |
|             ------|
---------------------
```

# How grab events

|watch fo interrupts|Grab events|Trigger an event|
|---|---|---|
|watch -n 0.5 "cat /proc/interrupts  \| awk '/DIO_IN/'"|evtest --grab /dev/input/by-path/platform-gpio-keys-event|sudo iotg-imx8plus-dio -o 2 $(($((i++))%2))|
