#!/bin/bash -ex

modprobe trusted
KEYNAME=dm_trust
BLOB=/opt/encrypt.d/KEYNAME.blob
if [[ ! -e ${BLOB} ]];then
	KEY="$(keyctl add trusted $KEYNAME 'new 32' @s)"
	keyctl pipe $KEY > $BLOB
else
	keyctl add trusted $KEYNAME "load $(cat $BLOB)" @s
fi
keyctl list @s
