# CompuLab EdgeAI-ORN flash manual

* Supported CompuLab HW:
  * EdgeAI-ORN:Jetson™ Orin NX 16GB
  * EdgeAI-ORN:Jetson™ Orin NX 8GB
  * EdgeAI-ORN:Jetson™ Orin NANO 8GB
  * EdgeAI-ORN:Jetson™ Orin NANO 4GB

* Prerequisites:
  * Linux desktop PC.
  * CompuLab SW:
    * Browse this [location](https://drive.google.com/drive/folders/1uiRUAJ_uJPLlE4fgNYuHuHkek04k_FBC):
    * Download an ``mfi_edge-ai.tar.gz`` archive that matches the setup configuration.
    * Download the ``mfi_edge-ai.sh`` file.
  * Connectivity:
    * The EdgeAI-ORN device must be connected to a Linux desktop by:
      * Recovery USB port
      * Console USB port

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
* Issue this commad to start the process:
  ```
  MFI_FOLDER=/path/to/mfi-folder/mfi_edge-ai sudo -E /path/to/mfi-folder/mfi_edge-ai.sh
