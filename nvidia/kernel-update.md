# Linux Kernel Update

* Download the [linux-kernel](https://drive.google.com/file/d/1uEH2KHBTp2yiqlAIGkd0LSoCPGoB_r3q/view?usp=drive_link).
* Copy it to the Edge-AI device.
* Issue this command:
```
sudo tar -C / --keep-directory-symlink -xf /path/to/linux-kernel-5.15.148-tegra.tar.bz2
```
* Update the Nvidia inirtd, issue:
```
sudo nv-update-initrd
```
* Update the ``/boot/extlinux/extlinux.conf`` file:<br>
  * Disable the network interfaces renaming (optiona):
    ```
    sudo sed -i "s/\(APPEND\)/\1 net.ifnames=0/g;" /boot/extlinux/extlinux.conf
    ```
  * Set CompuLab device tree:
    ```
    sudo sed -i "/root=/i\      FDT /boot/dtbs/tegra234-p3768-0000+p3767-0005-nv-super-compulab.dtb" /boot/extlinux/extlinux.conf
    ```
* Reboot machine, login and issue:
```
uname -v
#8 SMP PREEMPT Sat Oct 25 23:03:38 IDT 2025
```
