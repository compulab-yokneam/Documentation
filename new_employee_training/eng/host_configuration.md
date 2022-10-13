1. Linaro toolchain istallation:
  * For `armhf` platform refer to [this](https://github.com/compulab-yokneam/meta-bsp-imx7/blob/devel-warrior/Documentation/toolchain.md) document
  * For `aarch64` platform refer to [this](TBD) document

2. Additional essential packages on build host to ne installed:
  ```
  bc bison bsdmainutils build-essential cmake curl locales \
  flex g++-multilib gcc-multilib git gnupg gperf lib32ncurses5-dev \
  lib32z1-dev libncurses5-dev git-lfs \
  libsdl1.2-dev libxkbcommon-x11-0 libwayland-cursor0 libxml2-utils lzop \
  openjdk-8-jdk lzop wget git-core unzip \
  genisoimage sudo socat xterm gawk cpio texinfo \
  gettext vim diffstat chrpath rsync lz4 zstd \
  python-mako python-is-python3 libusb-1.0-0-dev exuberant-ctags \
  pngcrush schedtool xsltproc zip zlib1g-dev libswitch-perl tree
  ```
