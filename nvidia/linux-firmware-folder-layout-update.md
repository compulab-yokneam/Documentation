# Linux Firmware Folder Layout Update

* Get connected to the Edge-AI device.
* Issue these command:
```
sudo -i
cd /lib/firmware/
mkdir iwlwifi.d
mv iwlwifi-* iwlwifi.d/
ln -s iwlwifi.d/iwlwifi-cc-a0-62.ucode
ln -s iwlwifi.d/iwlwifi-ty-a0-gf-a0-62.ucode
```
