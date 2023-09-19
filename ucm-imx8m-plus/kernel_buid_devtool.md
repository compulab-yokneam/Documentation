# Modifying the CompuLab Linux Kernel using devtool

## Go to the Yocto build environment:
```
cd ${BUILDDIR}
```

## Create the linux kernel tree snapshot:
```
devtool modify linux-compulab
```

## Go to the linux kernel source tree and modify it if required:
```
cd ${BUILDDIR}/workspace/sources/linux-compulab
```

## Build the linux kernel from the modified snapshot:
```
devtool build linux-compulab
```

Make sure that the command returns no compilation error.

## Issue the entire image build with the modified kernel:
```
bitbake -k imx-image-full
```


|!NOTE!|Don’t try modifying kernel source at ${MACHINE}/tmp/work/${MACHINE}-poky-linux/linux-compulab/${VERSION}|
|---|---|
