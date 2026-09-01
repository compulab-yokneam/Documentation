# Fast ARM64 Linux Kernel Builds in a Debian 12 Chroot

## Diagnosis

The development host is an x86-64 system with an Intel Core i9-14900K,
32 logical CPUs, and 125 GiB of RAM. The following programs in the existing
Debian rootfs are ARM64 executables:

- `/bin/sh`
- `/usr/bin/make`
- `/usr/bin/gcc`

Consequently, building inside that ARM64 chroot runs the compiler and all
supporting build programs through QEMU user-mode emulation. This is native
ARM64 compilation under emulation, rather than true cross-compilation, and is
the primary performance bottleneck.

The recommended solution is to continue using a Debian 12 chroot, but create
an `amd64` chroot and install an ARM64 cross-toolchain in it. Build programs
then run natively on the x86-64 host while producing ARM64 output.

## Create an amd64 Debian 12 chroot

On the development host:

```bash
CHROOT=/home/val/devel/chroots/debian-bookworm-amd64-buildd

sudo apt-get install debootstrap
sudo debootstrap \
    --arch=amd64 \
    bookworm \
    "$CHROOT" \
    http://deb.debian.org/debian
```

Mount the required virtual filesystems and enter the chroot:

```bash
sudo mount --rbind /dev "$CHROOT/dev"
sudo mount --make-rslave "$CHROOT/dev"
sudo mount -t proc proc "$CHROOT/proc"

sudo chroot "$CHROOT" /bin/bash
```

Inside the chroot, install the build environment:

```bash
apt-get update

apt-get install \
    crossbuild-essential-arm64 \
    bc bison flex \
    libssl-dev libelf-dev \
    dwarves cpio rsync kmod \
    fakeroot dpkg-dev ccache
```

The Debian `crossbuild-essential-arm64` package supplies the ARM64 GCC
cross-toolchain:

https://packages.debian.org/bookworm/crossbuild-essential-arm64

## Bind the kernel source and output directories

Run these commands on the development host. Adjust `KERNEL_SRC` if a different
workspace contains the kernel being built.

```bash
CHROOT=/home/val/devel/chroots/debian-bookworm-amd64-buildd
KERNEL_SRC=/home/val/devel/yocto/scarthgap-6.6.52-2.2.0/compulab-nxp-bsp/build-iot-link/workspace/sources/linux-compulab
KERNEL_OUT=/home/val/devel/kernel-build/iot-link

sudo mkdir -p "$CHROOT/src/linux-compulab" "$KERNEL_OUT" "$CHROOT/build"
sudo mount --bind "$KERNEL_SRC" "$CHROOT/src/linux-compulab"
sudo mount --bind "$KERNEL_OUT" "$CHROOT/build"
```

Enter the chroot again:

```bash
sudo chroot "$CHROOT" /bin/bash
```

## Build the ARM64 kernel packages

Inside the amd64 chroot:

```bash
cd /src/linux-compulab

make O=/build \
    ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    olddefconfig

make -j32 O=/build \
    ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    KBUILD_DEBARCH=arm64 \
    bindeb-pkg
```

Use the project's existing configuration-generation command instead of
`olddefconfig` when appropriate. The kernel documents `ARCH`, `CROSS_COMPILE`,
and `KBUILD_DEBARCH` here:

https://docs.kernel.org/kbuild/kbuild.html

Use `bindeb-pkg` instead of `deb-pkg` when only binary Debian packages are
required.

## Enable ccache for incremental builds

Keep the cache under the persistent output directory:

```bash
export CCACHE_DIR=/build/.ccache
ccache --max-size=40G

make -j32 O=/build \
    ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CC="ccache aarch64-linux-gnu-gcc" \
    HOSTCC="ccache gcc" \
    KBUILD_DEBARCH=arm64 \
    bindeb-pkg
```

Additional recommendations:

- Preserve `/build` between builds.
- Start with `-j32` and compare it with `-j24` on the hybrid-core i9-14900K.
- Avoid cleaning the output directory unless the configuration change requires
  it.
- A tmpfs output directory can reduce write latency, but is secondary to
  eliminating QEMU compiler emulation and loses its contents at reboot.

## If the ARM64 chroot must be retained

Using `make -j32` and a persistent `ccache` can improve incremental builds, but
the ARM64 compiler and build tools will still run under QEMU. This cannot match
the performance of an amd64 chroot using a native x86-64-hosted cross-compiler.

KVM cannot accelerate ARM64 code on an x86-64 processor. If an actual native
ARM64 userspace is mandatory, use a physical ARM64 build server instead.

## Unmount the chroot

After leaving the chroot and ensuring no process is using it:

```bash
sudo umount "$CHROOT/build"
sudo umount "$CHROOT/src/linux-compulab"
sudo umount "$CHROOT/proc"
sudo umount -R "$CHROOT/dev"
```
