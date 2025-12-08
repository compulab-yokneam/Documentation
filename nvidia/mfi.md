# CompuLab EdgeAI-ORN flashing manual

* Supported CompuLab HW:
  * EdgeAI-ORN:Jetson™ Orin NX 16GB
  * EdgeAI-ORN:Jetson™ Orin NX 8GB: rootfs_bootloader
  * EdgeAI-ORN:Jetson™ Orin NANO 8GB: rootfs_bootloader
  * EdgeAI-ORN:Jetson™ Orin NANO 4GB: rootfs_bootloader

* Provided SW:

  |HW|Bootloader+Rootfs|Bootloader Only|
  |---|---|---|
  |EdgeAI-ORN:Jetson™ Orin NX 16GB|*|*|
  |EdgeAI-ORN:Jetson™ Orin NX 8GB|*||
  |EdgeAI-ORN:Jetson™ Orin NANO 8GB|*||
  |EdgeAI-ORN:Jetson™ Orin NANO 4GB|*||
  
* Prerequisites:
  * Linux desktop PC.
  * CompuLab SW:
    * Browse this [location](https://drive.google.com/drive/folders/1uiRUAJ_uJPLlE4fgNYuHuHkek04k_FBC).
    * Download an ``mfi_edge-ai.tar.gz`` archive that matches the setup configuration.
    * Download the ``mfi_edge-ai.sh`` file.
  * Connectivity:
    * The EdgeAI-ORN device must be connected to a Linux desktop by:
      * Recovery/Programming USB port
      * Console/Debug USB port

# Prepare the flashing software:
* Unpack the ``mfi_edge-ai.tar.gz``
  ```
  mkdir -p /path/to/mfi-folder
  cd /path/to/mfi-folder
  tar -xf /path/to/mfi-download/mfi_edge-ai.tar.gz
  ```
* Copy the ``mfi_edge-ai.sh`` to the same folder:
  ```
  cp /path/to/mfi-download/mfi_edge-ai.sh /path/to/mfi-folder
  chmod a+x /path/to/mfi-folder/mfi_edge-ai.sh
  ```

# Flashing the device:
  * Issue a power cycle for the device.
  * Make sure that the device turns out in the ``lsusb`` list as an:
    ```
    Bus XXX Device XXX: ID 0955:7523 NVIDIA Corp. APX
    ```
  * (Optional) Connect the device serial consle to the desktop PC.
    * Open up a terminal window and issue:
      ```
      udevadm monitor --subsystem-match tty
      ```
    * Connect one end of the usb cable to the host usb port, and the other ``type-C`` end to the device debug/console port.
    * As soon as the cable connected to the device, the lines like these show up in the ``udevadm monitor ``  window:
      ```
      KERNEL[27183.326354] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4:1.0/ttyUSB1/tty/ttyUSB1 (tty)
      UDEV  [27183.416422] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4:1.0/ttyUSB1/tty/ttyUSB1 (tty)
      ```
    * Take the device reported by the ``udevadm`` (in this example it is ``ttyUSB1``) and open up a serial terminal application:
      ```
      minicom -D /dev/ttyUSB1 115200
      ```
      The serial port settings must be:
      |Serial port setup|Name|Value|
      |---|---|---|
      ||Bps/Par/Bits|115200 8N1|
      ||Hardware Flow Control|No|
      ||Software Flow Control|No|
  * Issue this commad to start the process:
    ```
    MFI_FOLDER=/path/to/mfi-folder/mfi_edge-ai sudo -E /path/to/mfi-folder/mfi_edge-ai.sh
    ```
    The Unity OEM configuration sreen shows up at the connected HDMI panel at the end of the process.<br>
    Take the recovery cable off and continue evaluating the device.
    
    
