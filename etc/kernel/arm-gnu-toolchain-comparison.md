# Arm GNU Toolchain Target Comparison

### `aarch64-none-elf` vs `aarch64-none-linux-gnu`

The key difference is the target execution environment:

| Archive | Target | C library/sysroot | Intended use |
| --- | --- | --- | --- |
| `aarch64-none-elf` | Bare-metal AArch64 | Newlib-based embedded runtime; no Linux ABI | Firmware, bootloaders, Trusted Firmware-A, RTOS, standalone programs |
| `aarch64-none-linux-gnu` | AArch64 Linux | glibc, Linux headers, startup objects and Linux sysroot | Linux kernel, kernel packaging, shared libraries and Linux applications |

Both compilers generate AArch64 machine code. Arm provides separate variants for bare-metal development and Linux
kernel/application development.

Reference: [Arm GNU Toolchain overview](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads)

### `aarch64-none-elf`

Compiler prefix:

```text
aarch64-none-elf-
```

Characteristics:

- Produces freestanding/bare-metal ELF binaries.
- Has no Linux system-call ABI.
- Normally links statically.
- Uses Newlib for optional C-library functionality.
- Requires platform-provided startup code, a memory layout/linker script and
  low-level system-call stubs.
- Cannot produce ordinary Linux userspace executables.

Newlib is designed for embedded systems and requires the target platform to
provide low-level functions when no operating system exists.

Reference: [Newlib documentation](https://sourceware.org/newlib/libc.html)

Typical projects include:

```text
Trusted Firmware-A
UEFI firmware
bare-metal test programs
RTOS applications
some U-Boot configurations
```

### `aarch64-none-linux-gnu`

Compiler prefix:

```text
aarch64-none-linux-gnu-
```

Characteristics:

- Targets the AArch64 Linux userspace ABI.
- Includes a glibc-based sysroot and Linux kernel headers.
- Supplies startup objects such as `crt1.o`.
- Can create static executables, dynamic executables, shared libraries and
  PIE binaries.
- Supports Linux system calls, POSIX APIs, threads and the Linux dynamic
  loader.
- Can link ARM64 helper programs needed during Linux package/header
  generation.

The GNU C Library provides the POSIX, GNU and Linux interfaces and relies on
Linux kernel headers to define its kernel interface.

References:

- [glibc documentation](https://sourceware.org/glibc/manual/latest/html_mono/libc.html)
- [glibc build requirements](https://sourceware.org/glibc/manual/latest/html_node/Configuring-and-compiling.html)

## Linux kernel builds

For a normal kernel-only build, both compilers may work because the Linux
kernel is freestanding and does not link against libc:

```bash
make ARCH=arm64 \
  CROSS_COMPILE=aarch64-none-elf- \
  Image modules dtbs
```

For `bindeb-pkg`, use the Linux-targeting compiler:

```bash
CROSS_COMPILE=aarch64-none-linux-gnu-
```

The Linux-GNU variant is the better choice because Debian packaging can need
to compile ARM64 userspace helper programs. The bare-metal toolchain cannot
link those helpers against an ARM64 libc.

The Linux-GNU toolchain does not provide third-party libraries such as
OpenSSL. A complete cross-build that includes `linux-headers` can therefore
still require:

```text
libssl-dev:arm64
```

When the headers package is not needed, the supported Debian build profile
can exclude it:

```bash
DEB_BUILD_PROFILES=pkg.linux-upstream.nokernelheaders
```

With this profile, either compiler can generally build the kernel image
packages, although `aarch64-none-linux-gnu` remains the appropriate Linux
target.

## Summary

```text
Firmware or bare metal       -> aarch64-none-elf
Linux kernel and bindeb-pkg  -> aarch64-none-linux-gnu
Linux userspace applications -> aarch64-none-linux-gnu only
```
