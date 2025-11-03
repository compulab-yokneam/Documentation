# Post Deployment Customization

* Update the ``/boot/extlinux/extlinux.conf`` file:<br>
  * Mandatory: Set CompuLab device tree:

    |NOTE|Reason of not being enabled by default:<br>The Nvidia Customization GUI must have the type-c port configued as a device<br>at the very 1-st start.|
    |---|---|

    ```
    sudo sed -i "/root=/i\      FDT /boot/dtbs/tegra234-p3768-0000+p3767-0005-nv-super-host.dtb" /boot/extlinux/extlinux.conf
    ```
  * Optional: Disable the network interfaces renaming:
    ```
    sudo sed -i "s/\(APPEND\)/\1 net.ifnames=0/g;" /boot/extlinux/extlinux.conf
    ```
  
