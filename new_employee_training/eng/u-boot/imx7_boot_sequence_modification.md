# Preparation steps
## Host configuration
## Getting U-Boot Sources
## Building Firmware Image

# Task 1: 
* Create bootable [SD card](https://mediawiki.compulab.com/w/index.php?title=CL-SOM-iMX7:_U-Boot:_Creating_a_bootable_SD_card)
* Boot from [SD card](https://mediawiki.compulab.com/w/index.php?title=CL-SOM-iMX7:_U-Boot:_Creating_a_bootable_SD_card#Booting_from_an_SD_card)
* Make sure the device is booted from SD card: analyse serial console log and verify:
  * Boot media
  * Build timestamp
* Update Firmware on the SPI flash from any media [SD/USB/TFTP](https://mediawiki.compulab.com/w/index.php?title=CL-SOM-iMX7:_U-Boot:_Firmware_Update)
* Boot from SPI flash and verify:
  * Boot media
  * Build timestamp

# Task 2: Enhance support for USB storage as boot media
> Enhance support for USB storage as boot media in the default U-Boot environment.

**Assumptions:**
* No more than one USB storage device can be plugged
* To ensure loading boot script the USB storage device must have at least one partition:
  * Formatted with either ext2/3/4 or FAT file system and
  * Containing at least boot script image
* To ensure loading kernel, fdt and mounting root filesystem the USB storage device must have at least two partition:
  * First one:
    * formatted with either ext2/3/4 or FAT file system and
    * containing at least kernel image and fdt file (device tree blob)
  * Second one:
    * formatted with either ext2/3/4 or FAT file system and
    * containing a proper Linux root filesystem

**Requirements:**
1. USB storage shall be the first boot media.
2. U-Boot shall try to load a boot script from the first USB device partition and run it as the very first option.
3. If not found U-Boot shall fall back to the next step.
4. U-Boot shall try to load a kernel and fdt (device tree blob) from the first USB device partition and setup bootargs variable to lookup rootfs on the second USB device partition as the next option.
5. If kernel or fdt not found U-Boot shall fall back to the next step.
6. The rest of the boot sequence shall be preserved
7. No user intervention is required to ensure automatic boot

**Testing and verifying:**
> The full boot sequence shall be tested and verified

**Expected results:**
1. Prepare a patch that is smoothly applied on the top of the git repository cloned in the section "Getting U-Boot Sources"
2. Provide firmware binary
