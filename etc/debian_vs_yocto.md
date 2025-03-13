# Debian vs Yocto

|NOTE|CompuLab provides both Debian and Yocto distro|
|---|---|

* Features

|(V)Features:Distro(>)|Debian|Yocto|
|:---|:---|:---|
|O/S image ownership|Compulab|Developer (customer)|
|Distro maintenance/update|Official Debian distro maintainer|Developer (customer)|
|Package Manager|apt/dpkg with the official Debian repository|Developer's repository using [apt/dpkg with the Yocto distro](https://github.com/compulab-yokneam/Documentation/wiki/Yocto-deb-repository)|
|OTA|Available with [Mender-Converter](https://github.com/compulab-yokneam/mender-convert-compulab)|Available with [Mender](https://github.com/compulab-yokneam/meta-mender-compulab)|
|OS image snapshot (golden image)|Available by cl-deploy|Available by cl-deploy|
