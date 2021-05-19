# imx8mp sbc/ekv atp


* Prepare the setup

http://192.168.11.170/Devel/Work/ATP/atp/machines/i.MX8MP/atp.d/20210519_101447.jpg

* Prepare a bootable sd-card:
```
wget http://192.168.11.170/Devel/Work/ATP/atp/machines/i.MX8MP/boot/tools/prod-boot.img.100
dd if=prod-boot.img.100 of=/dev/sdX bs=1M
```

## ATP Procedure
1) Issue alt boot: ```Press and hold SW7 & SW6; Release SW6 and then SW7```
2) As soon as the banner reset request shows up, press SW6
3) The deviec loads the kerned & dtb from the ATP server.
4) At the and of the boot thos scren turns out:
```
[Aa] - ATP Start
[Ii] - ATP Init
[Gg] - CLERP log info
[Dd] - CLERP del info
[Xx] - Exit atp.shell
[Bb] - Fast reboot

atp.shell ( device: i.MX8MP ;  status  [  ] ) > 
```
## Module ATP:
```
5.0) Press 'I' ,the 'A'
5.1) Scan the module label
5.2) Let the process run and wait for a `success` message
```

## SB ATP:
```
6.0) Press 'I' ,the 'A'
6.1) Scan the base label
6.2) Let the process run and wait for a `success` message
```

## SBC ATP
```
7.0) type: `export PROD_DEBUG=SBC-UCMIMX8PLUS`
7.1) Press `A`
7.2) Let the process run and wait for a `success` message
```

* That is all.
