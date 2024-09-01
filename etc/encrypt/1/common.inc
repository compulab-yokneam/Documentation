ENCVOLUME=encrypted
IMAGE=/data/${ENCVOLUME}-volume.img
ALGO="capi:cbc(aes)-plain"
KEYNAME=dm_trust
BLOCKS=262144
TARGET=crypt
BLOB=${SWD}/KEYNAME.blob

