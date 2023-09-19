# Modifying the CompuLab Linux Kernel using devtool

## Go to the Yocto build environment
```
cd ${BUILDDIR}
```

## devtool modify
```
devtool modify linux-compulab
```

## go to the Linux kernel source tree and modify it if required:
```
cd ${BUILDDIR}/workspace/sources/linux-compulab
```

## devtool build
```
devtool build linux-compulab
```

Make sure that the command returns no compilation error.

## Issue the entire image build with the modified kernel
```
bitbake -k imx-image-full
```


|!NOTE!|Don’t try modifying kernel source at ${MACHINE}/tmp/work/${MACHINE}-poky-linux/linux-compulab/${VERSION}|
|---|---|
