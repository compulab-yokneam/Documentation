Dear Basler Support.

I’m a CompuLab SW engineer.
My task is to make a Basler daA2500-60mci sensor work with the CompuLa imx8mp EVK.

We’ve cerated a Yocto Kirston imx-full-image + https://github.com/basler/meta-basler-imx8/tree/kirkstone-5.15.71-2.2.0
But we have an issue when we use a capturing sw. Below is the issue description.

# Issue description

Setup:
+ HW: CompuLab imx8mp EVK + daA2500-60mci
+ SW: NXP Yocto Kirkstone + meta-basler-imx8

Issued command:<br>
The board starts and a gst capture command gets issued:
```
gst-launch-1.0 -v v4l2src device=/dev/video2 ! waylandsink
```

Result:<br>
The capturing does not start due to the fact that the /opt/imx8-isp/bin/isp_media_server crashes.

| NOTE |The same test works on the same environment but with a Basler DAA3840_30MC sensor |
|---|---|

Good and Bad sensors test snapshots are attached:

bad: https://github.com/compulab-yokneam/Documentation/blob/master/issues/basler/2500.md<br>
good: https://github.com/compulab-yokneam/Documentation/blob/master/issues/basler/3840.md

I’d appreciate it if you could shed light on the issue.
