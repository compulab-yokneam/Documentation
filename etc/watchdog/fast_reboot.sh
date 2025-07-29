#!/bin/bash -x

cat << eof
Rebooting ...
eof

for c in s u b;do
echo ${c} > /proc/sysrq-trigger
done

exit 0
