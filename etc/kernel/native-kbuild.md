# Native-Host ARM64 Linux Kernel Cross-Build

## Build environment

The kernel is built directly on the x86-64 Ubuntu development host:

```text
Kernel tree:
/home/val/devel/yocto/wrynose-6.18.20-2.0.0/compulab-imx95-bsp/build-imx8mp-lpddr4/workspace/sources/linux-compulab-clone

Cross-toolchain prefix:
/opt/gcc-16.1.0-nolibc/aarch64-linux/bin/aarch64-linux-
```

The cross-compiler is an x86-64 executable that generates ARM64 code, so it
runs natively and does not use QEMU emulation.

The kernel architecture must be written as `arm64`:

```bash
export ARCH=arm64
```

`ARCH=arm4` is invalid.

## Cause of the libssl-dev dependency failure

The host already has the native OpenSSL development package installed:

```text
libssl-dev:amd64  3.0.13-0ubuntu3.15
```

Linux 6.18 generates these relevant build dependencies:

```text
libssl-dev:native,
libssl-dev <!pkg.linux-upstream.nokernelheaders>
```

The first dependency is satisfied by `libssl-dev:amd64`. During an ARM64
cross-build, the second, unqualified dependency resolves to
`libssl-dev:arm64`. It is required when the ARM64 `linux-headers` package is
built and is the source of this error:

```text
dpkg-checkbuilddeps: error: Unmet build dependencies: libssl-dev
```

## Recommended image-only build

If only the kernel image packages are needed, disable creation of the kernel
headers package with the build profile provided by the kernel packaging code:

```bash
cd /home/val/devel/yocto/wrynose-6.18.20-2.0.0/compulab-imx95-bsp/build-imx8mp-lpddr4/workspace/sources/linux-compulab-clone

export ARCH=arm64
export CROSS_COMPILE=/opt/gcc-16.1.0-nolibc/aarch64-linux/bin/aarch64-linux-
export DEB_BUILD_PROFILES=pkg.linux-upstream.nokernelheaders

make -j32 \
    CC="ccache ${CROSS_COMPILE}gcc" \
    HOSTCC="ccache gcc" \
    KBUILD_DEBARCH=arm64 \
    bindeb-pkg
```

The dependency check succeeds on this host with the
`pkg.linux-upstream.nokernelheaders` profile.

If neither the headers nor the debug-symbol package is needed, use both build
profiles:

```bash
export DEB_BUILD_PROFILES="pkg.linux-upstream.nokernelheaders pkg.linux-upstream.nokerneldbg"
```

Then run the same `make` command.

## Building the linux-headers package

If the ARM64 `linux-headers` package is required, both the native and target
OpenSSL development packages must be installed:

```bash
sudo dpkg --add-architecture arm64
sudo apt-get update
sudo apt-get install libssl-dev:amd64 libssl-dev:arm64
```

Ubuntu hosts generally obtain ARM64 packages from:

```text
http://ports.ubuntu.com/ubuntu-ports
```

The existing amd64 Ubuntu sources should remain restricted to `amd64`, and a
separate ARM64 source should be configured for `ports.ubuntu.com`. Do not
replace or remove `libssl-dev:amd64`; native kernel build utilities still need
it.

The headers packaging code also uses Debian's standard cross-compiler name,
`aarch64-linux-gnu-gcc`. This host already has the corresponding
`gcc-aarch64-linux-gnu:amd64` package installed.

## Verification

Check the host and installed development packages:

```bash
dpkg --print-architecture
dpkg --print-foreign-architectures

dpkg-query -W \
    -f='${binary:Package}\t${db:Status-Abbrev}\t${Architecture}\t${Version}\n' \
    libssl-dev:amd64 libssl-dev:arm64 gcc-aarch64-linux-gnu
```

Check the dependencies without the headers package:

```bash
cd /home/val/devel/yocto/wrynose-6.18.20-2.0.0/compulab-imx95-bsp/build-imx8mp-lpddr4/workspace/sources/linux-compulab-clone

DEB_BUILD_PROFILES=pkg.linux-upstream.nokernelheaders \
    dpkg-checkbuilddeps -a arm64 -B
```

No output and a zero exit status mean that the dependencies are satisfied.
