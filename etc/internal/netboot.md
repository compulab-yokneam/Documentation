# TFTP/NFS how to

| NOTE |This document assumes that readers are familiar with Linux/Unix operation systems and NFS/TFTP server configurations.|
|---|---|

* U-Boot environment for booting a boot script from a configured tftp server:
<pre>
# Available net ifaces
## Internal NXP ehthernet ifaces
setenv fec_net  ethernet@30be0000
setenv eqos_net ethernet@30be0000
## ax88179 is a usb-ethernet adapter used for phyless configurations
setenv usb_net ax88179_eth

setenv net_cfg_done no
setenv get_ip "dhcp"

# Take this value from the tftp server configuration
setenv tftp_server_export /var/lib/tftpboot

setenv bootscript ${tftp_server_export}/boot.tftp.scr

if test ${ethprime} = "eth0"
then
 setenv ip_cmd ":::::eth0:dhcp"
 setenv net_cfg_done yes
fi

if test ${ethprime} = "eth1"
then
 setenv ip_cmd ":::::eth0:dhcp"
 setenv net_cfg_done yes
fi

if test ${net_cfg_done} = "no"
then
 setenv ethaddr
 setenv ethact ${usb_net}
 setenv ethprime ${usb_net}
 setenv ip_cmd ":::::eth2:dhcp"
 setenv get_ip "usb reset; dhcp"
fi

run get_ip

# Set the ip adresses for the tftp and for the nfs servers
setenv serverip  ${TFTP_SERVER_IP}
setenv nfsserver ${NFS_SERVER_IP}

tftpboot ${loadaddr} ${serverip}:${bootscript} && source ${loadaddr}
</pre>
* TFTP located boot script:
<pre>
setenv image "${tftp_server_export}/Image.gz"
setenv fdt_file "${tftp_server_export}/ucm-imx8m-plus.dtb"
setenv console "console=ttymxc1,115200"
setenv nfsroot "${nfsserver}:/export/rootfs"
setenv bootargs "root=/dev/nfs ip=${ip_cmd} ${console} nfsroot=${nfsroot} rw rootwait

setenv load_kernel 'tftpboot ${initrd_addr} ${serverip}:${image};unzip ${initrd_addr} ${loadaddr}'
setenv load_fdt 'tftpboot ${fdt_addr} ${serverip}:${fdt_file}'
setenv bootcmd 'run load_kernel && run load_fdt && booti ${loadaddr} - ${fdt_addr};'
boot
</pre>

* Creating the tftp boot script
<pre>
mkimage -C none -O Linux -A arm -T script -d /path/to/boot.tftp /path/to/boot.tftp.scr
</pre>
