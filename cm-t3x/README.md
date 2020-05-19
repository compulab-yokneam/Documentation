# Create a build directory:
<pre>
mkdir ~/development/cm-t3x/{u-boot,package} && ~/development/cm-t3x/package
</pre>

# Download the CompuLab cm-t3x u-boot package and unpack it:
<pre>
wget https://www.compulab.com/wp-content/uploads/2014/04/cm-t3730_u-boot_2014-04-01.zip
unzip cm-t3730_u-boot_2014-04-01.zip
</pre>

# Clone & Branch
<pre>
cd ~/development/cm-t3x/u-boot
git clone git://git.denx.de/u-boot.git u-boot-cm-t3x
git checkout -b 2014.01-cm-t3x-6 v2014.01
</pre>

# Apply the CM-T3x patch
<pre>
git am ~/development/cm-t3x/package/cm-t3730-u-boot/u-boot/patches/*.patch
</pre>

# Building the firmware images
## Building the U-Boot image
<pre>
export ARCH=arm
export CROSS_COMPILE=arm-none-linux-eabi-
make mrproper
make cm_t35
</pre>
* Results:
CM-T3x firmware U-Boot image (u-boot.bin) will be created in `~/development/cm-t3x/u-boot/u-boot-cm-t3x`

## Building X-Loader images
* Unzip the code:
<pre>
cd ~/development/cm-t3x
unzip ~/development/cm-t3x/package/cm-t3730-u-boot/x-loader/x-loader-cm-t3x-3.tar.gz
cd x-loader
</pre>
* Build
<pre>
export ARCH=arm
export CROSS_COMPILE=arm-none-linux-eabi-
make mrproper
make cm-t3x_config
make
</pre>
* Results:
 CM-T3x firmware X-Loader image (x-load.bin) will be created in `~/development/cm-t3x/x-loader/x-loader-cm-t3x`
