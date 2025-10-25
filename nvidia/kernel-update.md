# Linux Kernel Update

* Downlaod the [linux-kernel](https://drive.google.com/file/d/1e-p03dBWi3636tL5eNun_2lCZ_xNnW4S/view?usp=drive_link)
* Copy it to the Edge-AI device
* Issue this command:
```
sudo tar -C / --keep-directory-symlink -xf /path/to/linux-kernel-5.15.148-tegra.tar.bz2
```
* Update the ``/boot/extlinux/extlinux.conf`` file:
```
sudo sed -i "/root=/i\      FDT /boot/dtbs/tegra234-p3768-0000+p3767-0005-nv-super-compulab.dtb" /boot/extlinux/extlinux.conf
```
