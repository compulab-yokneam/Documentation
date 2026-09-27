# ARM64 `bindeb-pkg` Cross-Build Investigation and Report

Date: 2026-09-27

## Build environment

- Build host architecture: x86_64
- Target architecture: ARM64
- Kernel source tree:
  `/path/to/yocto/compulab-nxp-bsp/compulab-imx9-bsp/build-iot-link/workspace/sources/linux-compulab`
- Source commit:
  `88535e7ed968 dts: imx93: unify CompuLab platforms and add support of iot-link`
- Kernel release:
  `6.18.20-1.0-g88535e7ed968`
- Cross-compiler prefix:
  `/opt/gcc-16.1.0-nolibc/aarch64-linux/bin/aarch64-linux-`
- Compiler:
  `/opt/gcc-16.1.0-nolibc/aarch64-linux/bin/aarch64-linux-gcc`

## Reported failure

The original `bindeb-pkg` attempt stopped before compiling the kernel:

```text
dpkg-checkbuilddeps: error: Unmet build dependencies: libssl-dev
dpkg-buildpackage: warning: build dependencies/conflicts unsatisfied; aborting
```

The generated `debian/control` contained these architecture build
dependencies:

```text
Build-Depends-Arch: bc, bison, flex,
 gcc-aarch64-linux-gnu <!pkg.linux-upstream.nokernelheaders>,
 kmod, libdw-dev:native, libelf-dev:native,
 libssl-dev:native, libssl-dev <!pkg.linux-upstream.nokernelheaders>,
 python3:native, rsync
```

For an ARM64 cross-build, the unqualified second `libssl-dev` dependency is
interpreted as the target package `libssl-dev:arm64`. Only
`libssl-dev:amd64` was installed on the host, so `dpkg-checkbuilddeps`
rejected the build.

This target dependency is associated with the `linux-headers` binary package.
The kernel packaging scripts provide the
`pkg.linux-upstream.nokernelheaders` build profile for builds which do not
need that package. Enabling this profile removes both the headers package and
its target compiler/OpenSSL build dependencies.

The dependency check was verified independently with:

```bash
cd /path/to/yocto/compulab-nxp-bsp/compulab-imx9-bsp/build-iot-link/workspace/sources/linux-compulab

DEB_BUILD_PROFILES=pkg.linux-upstream.nokernelheaders \
  dpkg-checkbuilddeps -a arm64 -B
```

It completed successfully.

## Verified build command

Run the following command from the kernel source tree:

```bash
cd /path/to/yocto/compulab-nxp-bsp/compulab-imx9-bsp/build-iot-link/workspace/sources/linux-compulab

make -j32 \
  ARCH=arm64 \
  CROSS_COMPILE=/opt/gcc-16.1.0-nolibc/aarch64-linux/bin/aarch64-linux- \
  CC="ccache /opt/gcc-16.1.0-nolibc/aarch64-linux/bin/aarch64-linux-gcc" \
  HOSTCC="ccache gcc" \
  KBUILD_DEBARCH=arm64 \
  DEB_BUILD_PROFILES=pkg.linux-upstream.nokernelheaders \
  CCACHE_DIR=/tmp/ccache-arm64 \
  bindeb-pkg
```

Important details:

- `ARCH` must be `arm64`, not `arm4`.
- `KBUILD_DEBARCH=arm64` gives the generated Debian packages the ARM64
  architecture.
- `HOSTCC="ccache gcc"` builds temporary utilities which must run on the
  x86_64 build host.
- `CC` and `CROSS_COMPILE` build the kernel, modules, and target objects for
  ARM64.
- `CCACHE_DIR=/tmp/ccache-arm64` selects a writable compiler-cache directory.
- `DEB_BUILD_PROFILES=pkg.linux-upstream.nokernelheaders` avoids the missing
  target `libssl-dev:arm64` dependency and does not generate a
  `linux-headers` package.

## Build result

The command completed successfully. It produced:

```text
/path/to/yocto/compulab-nxp-bsp/compulab-imx9-bsp/build-iot-link/workspace/sources/linux-image-6.18.20-1.0-g88535e7ed968_6.18.20-g88535e7ed968-3_arm64.deb
/path/to/yocto/compulab-nxp-bsp/compulab-imx9-bsp/build-iot-link/workspace/sources/linux-image-6.18.20-1.0-g88535e7ed968-dbg_6.18.20-g88535e7ed968-3_arm64.deb
/path/to/yocto/compulab-nxp-bsp/compulab-imx9-bsp/build-iot-link/workspace/sources/linux-libc-dev_6.18.20-g88535e7ed968-3_arm64.deb
/path/to/yocto/compulab-nxp-bsp/compulab-imx9-bsp/build-iot-link/workspace/sources/linux-upstream_6.18.20-g88535e7ed968-3_arm64.buildinfo
/path/to/yocto/compulab-nxp-bsp/compulab-imx9-bsp/build-iot-link/workspace/sources/linux-upstream_6.18.20-g88535e7ed968-3_arm64.changes
```

Package metadata verification:

```text
Package: linux-image-6.18.20-1.0-g88535e7ed968
Version: 6.18.20-g88535e7ed968-3
Architecture: arm64

Package: linux-image-6.18.20-1.0-g88535e7ed968-dbg
Version: 6.18.20-g88535e7ed968-3
Architecture: arm64

Package: linux-libc-dev
Version: 6.18.20-g88535e7ed968-3
Architecture: arm64
```

## Binary architecture audit

All three generated `.deb` packages were extracted and every packaged ELF
file was inspected with `file`.

Results:

```text
AArch64 ELF files: 1581
x86 or x86_64 ELF files: 0
other ELF architectures: 0
```

The `HOSTCC` messages in the build log are expected. Programs such as
`fixdep`, Kconfig utilities, DTC, and other generators execute on the build
host and are therefore x86_64. They remain build artifacts and were not
included in the generated ARM64 packages.

## Toolchain-name warning

The build emits this warning:

```text
dpkg-architecture: warning: specified GNU system type aarch64-linux-gnu does not match CC system type aarch64-linux
```

Debian names the ARM64 GNU system type `aarch64-linux-gnu`, while the custom
nolibc toolchain reports `aarch64-linux`. This mismatch is only a warning and
did not affect the successful kernel or package build.

## Building the headers package

The verified command intentionally does not create `linux-headers`.

The custom `/opt/gcc-16.1.0-nolibc` compiler is suitable for building the
kernel, but it has no target C library and cannot link the ARM64 userspace
helper programs installed in a cross-built headers package. A complete build
including `linux-headers` requires a target userspace-capable toolchain and
the ARM64 development dependencies, including `libssl-dev:arm64`.

The host has Ubuntu's `aarch64-linux-gnu-gcc` and ARM64 cross-libc packages,
but `libssl-dev:arm64` was not installed. Do not bypass the dependency check
with `dpkg-buildpackage -d` unless the headers package is deliberately being
excluded or its target helper build has been handled separately.

## Repository state

No tracked kernel source files were changed during this investigation. The
fix is the corrected build environment and supported Debian build profile.
