#!/bin/bash -x

for w in /dev/watchdog*;do
cat ${w};
done

cat << eof
Panic...
eof

for c in s u c;do
echo ${c} > /proc/sysrq-trigger
done

exit 0
