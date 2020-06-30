# u-boot-script

This is a sample u-boot-script recipe that shows how to add a U-boot boot script to the Yocto build.

|Note|The recipe has an empty script for demo purpouse only.<br>Edit it and add update the `cond/local.conf` in order to alter the default boot environment|
|---|---|

* Update `conf/local.conf`

```
CORE_IMAGE_EXTRA_INSTALL += "u-boot-script"
IMAGE_BOOTFILES += "boot.scr"
```

