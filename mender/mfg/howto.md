# How to

## Customer side

* Define the MACHINE environment variadle:
```
export MACHINE=<iot-gate-imx8|iot-gate-imx8plus>
```

* How to prepare file for manufacturing:<br>
Issue these commands in the Yocto enabled build environment
```
cd ${BUILDDIR}/tmp/deploy/images/${MACHINE}
tar -cjhvf /path/to/mfg-folder/mfg-image.tar.bz2 cst-tools/hab/signed/u/flash.bin cst-tools/hab/signed/f/fuse.out *.mender *wic.zst
```

* Send thr created file `` /path/to/mfg-folder/mfg-image.tar.bz2`` to the manufacturer.

## Manufacturer side

The recieved file will get deployed onto the CompuLab ATP server.

* Bootloader<br>
The signed ``flash.bin`` binary will be flashed onto the internal media boot0 hw partition.

* Rootfs<br>
The provided rootfs will be deployed onto the intermal media user hw partition.

* fuse<br>
The fuse procedure will be issued at the end of ATP deployment as a part of the device validation restart.<br>
At the device validation restart the signed bootloader:<br>
```
1) Issues the fuse.out script;
2) Closes the device;
3) Turns the device off.
```
