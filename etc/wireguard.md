# Enable Wireguard

## Kernel config
* Enable the WIRGEGUARD as a module
```
CONFIG_WIREGUARD=m
```

## User space application
* Clone
```
git clone git://git.zx2c4.com/wireguard-tools
```
* Build and Install
```
make -C src
make -C src install
```
