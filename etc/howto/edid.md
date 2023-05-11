# Custom EDID how to

* Kernel config requirements:
```
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
```
* Use [Edid build manual](https://unix.stackexchange.com/questions/97023/how-to-make-edid) for creation a custom `edid.S` file.

* Sample steps:
```
gtf  640 480 60 -v
```
```
1: [H PIXELS RND]             :      640.000000
 2: [V LINES RND]              :      480.000000
 3: [V FIELD RATE RQD]         :       60.000000
 4: [TOP MARGIN (LINES)]       :        0.000000
 5: [BOT MARGIN (LINES)]       :        0.000000
 6: [INTERLACE]                :        0.000000
 7: [H PERIOD EST]             :       33.506584
 8: [V SYNC+BP]                :       16.000000
 9: [V BACK PORCH]             :       13.000000
10: [TOTAL V LINES]            :      497.000000
11: [V FIELD RATE EST]         :       60.050060
12: [H PERIOD]                 :       33.534538
13: [V FIELD RATE]             :       60.000004
14: [V FRAME RATE]             :       60.000004
15: [LEFT MARGIN (PIXELS)]     :        0.000000
16: [RIGHT MARGIN (PIXELS)]    :        0.000000
17: [TOTAL ACTIVE PIXELS]      :      640.000000
18: [IDEAL DUTY CYCLE]         :       19.939638
19: [H BLANK (PIXELS)]         :      160.000000
20: [TOTAL PIXELS]             :      800.000000
21: [PIXEL FREQ]               :       23.856001
22: [H FREQ]                   :       29.820002
17: [H SYNC (PIXELS)]          :       64.000000
18: [H FRONT PORCH (PIXELS)]   :       16.000000
36: [V ODD FRONT PORCH(LINES)] :        1.000000

  # 640x480 @ 60.00 Hz (GTF) hsync: 29.82 kHz; pclk: 23.86 MHz
  Modeline "640x480_60.00"  23.86  640 656 720 800  480 481 484 497  -HSync +Vsync
```
* Create a sample edid input file in the /path/to/kernel-source-tree/tools/edid folder.<br>
Our example is `tools/edid/640x480.S`:
```
cat tools/edid/640x480.S
```
```
/*
   1024x768.S: EDID data set for standard 1024x768 60 Hz monitor

   Copyright (C) 2011 Carsten Emde <C.Emde@osadl.org>

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version 2
   of the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA.
*/

/* EDID */
#define VERSION 1
#define REVISION 3

/* Display */
#define CLOCK 65000 /* kHz */
#define XY_RATIO XY_RATIO_4_3

#define XPIX 640
#define XBLANK  160
#define XOFFSET 16
#define XPULSE  64

#define YPIX 480
#define YBLANK 17
#define YOFFSET 1
#define YPULSE 3
#define DPI 72
#define VFREQ 60 /* Hz */
#define TIMING_NAME "Linux XGA"
#define ESTABLISHED_TIMING2_BITS 0x08 /* Bit 3 -> 1024x768 @60 Hz */
#define HSYNC_POL 0
#define VSYNC_POL 0

#include "edid.S"
```
* Issue make in the * Create a sample edid input file in the /path/to/kernel-source-tree/tools/edid folder.<br>
```
make -C /path/to/kernel-source-tree/tools/edid
```
* Place the created file /path/to/kernel-source-tree/tools/edid/640x480.bin onto the device `/lib/firmwared/edid/` folder with name `edid.bin`.
* Add this line to the kenel bootargs:
```
drm.edid_firmware=edid/edid.bin video=disp.screen0_output_mode=EDID:0
```
