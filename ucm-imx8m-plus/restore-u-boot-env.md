# U-Boot environment restore procedure

```
CONFIG_ENV_SIZE=0x4000
CONFIG_ENV_OFFSET=0x3F0000
UBOOT_ENV_OFFSET=$$(( $(CONFIG_ENV_OFFSET) >> 9))
cat u-boot-custom-env | mkenvimage -s $(CONFIG_ENV_SIZE) | dd of=<target-device> bs=512 seek=$(UBOOT_ENV_OFFSET)
```
