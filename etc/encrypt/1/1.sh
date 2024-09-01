#!/bin/bash -ex

SWD=$(dirname ${BASH_SOURCE[0]})
source ${SWD}/common.inc

modprobe trusted
if [[ ! -e ${BLOB} ]];then
	KEY="$(keyctl add trusted $KEYNAME 'new 32' @s)"
	keyctl pipe $KEY > $BLOB
else
	keyctl add trusted $KEYNAME "load $(cat $BLOB)" @s
fi
keyctl list @s
