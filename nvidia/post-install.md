# Post Deployment Customization

* Update the ``/boot/extlinux/extlinux.conf`` file:<br>
  * Mandatory: Set CompuLab device tree:

    |NOTE|Reason of not being enabled by default:<br>Some setups can't issue the Nvidia Customization GUI at the very 1-st atart|
    |---|---|

    ```
    sudo sed -i "/root=/i\      FDT /boot/dtbs/tegra234-p3768-0000+p3767-0005-nv-super-compulab.dtb" /boot/extlinux/extlinux.conf
    ```
  * Optional: Disable the network interfaces renaming:
    ```
    sudo sed -i "s/\(APPEND\)/\1 net.ifnames=0/g;" /boot/extlinux/extlinux.conf
    ```
  
