# Linux Kernel Update

* Download the [linux-kernel](https://drive.google.com/file/d/104-Bg6SE2IEbppS9V6kUwP5LIhJ13qIV/view?usp=sharing).
* Copy it to the Edge-AI device.
* Issue this command:
```
sudo tar -C / --keep-directory-symlink -xf /path/to/linux-kernel-5.15.148-compulab-tegra.tar.bz2
```
* Reboot machine, login and issue:
```
uname -r
5.15.148-compulab-tegra
```
