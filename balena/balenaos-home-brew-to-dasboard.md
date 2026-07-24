# How to

## BalenaOS image to the BalenaOS cloud dashboard

|The purpose of this chapter is to show<br>how to add the self created  BalenaOS image to the Balena cloud dashboard.|
|:---|

* Open up this page: https://dashboard.balena-cloud.com/fleets
* Issue:
  * "Create Flee"
  * "Add new device"
  * "Flash"->"Download configuration file only"

* On the running system:<br>
   Copy the downloaded file, for instance "iotdin.config.json", to the BalenaOS device to /mnt/boot/config.json
* On the build host:<br>
  ```
  sudo -i
  mount_point=$(mktemp --directory)
  cd ${BUILDDIR}/tmp/deploy/images/${MACHINE}/
  loop_device=$(losetup --show --find --partscan balena-image-${MACINE}.balenaos-img)
  mount ${loop_device}p1 ${mount_point}
  cp /path/to/iotdin.config.json ${mount_point}/config.json
  umount ${loop_device}p1
  losetup --detach ${loop_device}
  rm -rf ${mount_point}
  ```
