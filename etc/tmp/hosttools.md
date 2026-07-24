# Yocto host tools

* tar
  ```
  mkdir ${BUILDDIR}/prj-tools
  cd ${BUILDDIR}/prj-tools
  wget -O - https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz |  xzcat - | tar -xf -
  cd tar-1.35
  ./configure && make -j 8
  ln -fs $(readlink -e src/tar) ${BUILDDIR}/tmp/hosttools/
  ```
