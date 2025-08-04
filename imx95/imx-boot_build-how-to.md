* Cross & Environment
```
export SM_CROSS_COMPILE=/opt/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-
export OEI_CROSS_COMPILE=${SM_CROSS_COMPILE}
export TOOLS=/opt/imx-oei
export ARCH=arm
sudo mkdir -p ${TOOLS}
sudo ln -sf dirname $(dirname ${SM_CROSS_COMPILE}) ${TOOLS}/
```

* imx-oei
```
make -j 32 board=mx95lp5 DEBUG=1 DDR_CONFIG=lpddr5_timing r=B0 oei=ddr
make -j 32 board=mx95lp5 DEBUG=1 DDR_CONFIG=lpddr5_timing r=B0 oei=tcm
```

* imx-system-manager
```
make -j 32 V=y M=2 config=mx95cpl
```

* imx-boot all
```
make SOC=iMX95 REV=B0 OEI=YES LPDDR_TYPE=lpddr5 flash_all
```

* imx-boot w/out m7
```
make SOC=iMX95 REV=A0 OEI=YES LPDDR_TYPE=lpddr5 flash_all_no_m7
```
