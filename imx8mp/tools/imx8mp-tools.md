# imx8mp tools

* Clean up the dram settings page in i2c1@0x51:<br>
Issue this command as a root user:
  ```
  bash <(wget -qO - https://raw.githubusercontent.com/compulab-yokneam/Documentation/refs/heads/master/imx8mp/tools/ddr.clear)
  ```
* Update the device b2d4 bootloader:<br>
Issue this command as a root user:
  ```
  bash <(wget -qO - https://raw.githubusercontent.com/compulab-yokneam/Documentation/refs/heads/master/imx8mp/tools/d2d4.sh)
  ```
