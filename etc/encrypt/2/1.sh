#!/bin/bash -ex

modprobe trusted
KEY=0123456789abcdef
CAAMDIR=/data/caam
KEYNAME=fromTextkey
KEYFILE=${CAAMDIR}/${KEYNAME}
KEYBLOB=${KEYFILE}".bb"
if [[ ! -e "${KEYBLOB}" ]];then
	caam-keygen create ${KEYNAME} ecb -t 0123456789abcdef
else
	caam-keygen import ${KEYBLOB} ${KEYNAME}
fi
cat ${KEYFILE} | keyctl padd logon logkey: @s
