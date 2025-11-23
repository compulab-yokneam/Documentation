# MFI

* Prerequisites:
  * mfi_edge-ai.tar.gz -- MassFlash Orin NX 16G tarball
  * mfi_edge-ai.sh -- MassFlash deployer

* Download both file to a Linux Desktop:
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
