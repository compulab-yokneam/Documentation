#!/bin/bash

[[ -z ${1} ]] && exit 2

PKG=${1}                  
eval $(dpkg-deb -I ${PKG} | awk '(/Package:/)&&($0="PN="$NF)')

KID=/tmp/${PN}

rm -rf  ${KID} ; mkdir -p ${KID}

dpkg -x ${PKG} ${KID}
cp ${KID}/usr/lib/*/compulab/* ${KID}/boot/
mv ${KID}/boot/vmlinuz* ${KID}/boot/Image
rm -rf ${KID}/{usr,etc}                                    
fakeroot tar -C ${KID} -cjf ${KID}.tar.bz2 .
stat ${KID}.tar.bz2
