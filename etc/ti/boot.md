Here is the complete, end-to-end configuration procedure tailored specifically for your 172.16.50.1/24 subnet using the MLO file.
## Step 1: Set Up the Host USB Network Interface
When you plug in the AM437x board, your Linux host creates a temporary virtual interface named usb0. You must give it a static IP address matching your new subnet.
Run these commands on your host terminal:

```
bash
sudo ip addr add 172.16.50.1/24 dev usb0
sudo ip link set usb0 up
```

------------------------------
## Step 2: Install Necessary Servers
If you haven't installed them yet, install the DHCP/BOOTP and TFTP network packages:


```
bash
sudo apt update
sudo apt install isc-dhcp-server tftpd-hpa
```

------------------------------
## Step 3: Configure the DHCP/BOOTP Server
Open the DHCP configuration file with root privileges:

```
sudo vi /etc/dhcp/dhcpd.conf
```

Delete or comment out any existing configurations and paste the following block.<br>
Note that it explicitly points the ROM bootloader to ``MLO`` instead of ``u-boot-spl.bin``:

```
# DHCP/BOOTP configurations for AM437x USB Boot
subnet 172.16.50.0 netmask 255.255.255.0 {
    # Assign IPs to the board in the 172.16.50.x range
    range 172.16.50.2 172.16.50.10;
    
    # 1. ROM Bootloader checks for the RNDIS vendor ID and requests MLO
    if substring (option vendor-class-identifier, 0, 10) = "AM43xx 1.2" {
        filename "MLO";
    } 
    # 2. Once MLO boots, it requests the main U-Boot image
    else if substring (option vendor-class-identifier, 0, 17) = "AM43xx SPL u-boot" {
        filename "u-boot.img";
    }
    
    # Points the board directly to your host's TFTP server IP
    next-server 172.16.50.1;
}
```

Next, tell the DHCP server to listen exclusively on the usb0 interface to prevent conflicts with your main network:

```
sudo vi /etc/default/isc-dhcp-server
```

Modify the configuration line to look exactly like this:

``INTERFACESv4="usb0"``

## Step 4: Stage the Boot Files & Start Services
Copy your compiled MLO and u-boot.img binaries into the host system's default TFTP directory:

* Copy your files to the TFTP root folder
```
sudo cp /path/to/your/MLO /srv/tftp/
sudo cp /path/to/your/u-boot.img /srv/tftp/
```

* Fix permissions so the TFTP service can read them
```
sudo chmod 644 /srv/tftp/MLO
sudo chmod 644 /srv/tftp/u-boot.img
```

* Restart both network services to apply the updates
```
sudo systemctl restart tftpd-hpa
sudo systemctl restart isc-dhcp-server
```

## Step 5: Power Cycle and Boot

   1. Plug the AM437x USB cable into your host PC.
   2. Power on (or reset) the board.
   3. You can watch the entire network handshake happen in real-time by viewing the host system logs:
   ```
   sudo journalctl -u isc-dhcp-server -f
   ```
   
You should instantly see log entries showing an IP allocation (DHCPDISCOVER / DHCPOFFER) targeting the "AM43xx 1.2" profile, immediately followed by the file transfer.
Would you like to automate Step 1 via a udev rule so the usb0 interface assigns itself the 172.16.50.1 IP instantly every time you power cycle the board?

