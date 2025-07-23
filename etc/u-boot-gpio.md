# U-Boot gpio

## How to get the list of gpios:

* Stop in U-Boot and issue:
```
gpio status -a
```

```
Bank gpio@20_:
gpio@20_0: input: 1 [ ]
...
gpio@20_3: output: 1 [x] lvds0_panel.enable-gpios
gpio@20_4: input: 0 [ ]
...
gpio@20_15: input: 1 [ ]

Bank GPIO2_:
GPIO2_0: input: 0 [ ]
...
GPIO2_13: output: 1 [x] backlight.gpios
..
GPIO2_31: input: 1 [ ]
```

## How to change the gpio values:

* Toggle a gpio:

|gpio name|purpose|description|command|
|---|---|---|---|
|gpio@20_3|lvds0_panel.enable-gpios|toggling it makes the lvds panel switch off/on|```gpio toggle gpio@20_3```|
|GPIO2_13|backlight.gpios|toggling it makes the lvds panel go dark|```gpio toggle GPIO2_13```|
