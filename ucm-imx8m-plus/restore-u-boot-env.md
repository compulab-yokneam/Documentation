# U-Boot environment restore procedure

```
# Size in bytes
CONFIG_ENV_SIZE=0x4000 
# Size in 512-byte sectors
CONFIG_ENV_OFFSET=0x3F0000
# 1-byte to 512-byte conversion
UBOOT_ENV_OFFSET=$$(( $(CONFIG_ENV_OFFSET) >> 9))
# u-boot-custom-env -- U-Boot environment file
cat u-boot-custom-env | mkenvimage -s $(CONFIG_ENV_SIZE) | dd of=<target-device> bs=512 seek=$(UBOOT_ENV_OFFSET)
```
