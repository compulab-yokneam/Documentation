#!/bin/bash

for bus in $(i2cdetect -l | awk '($0=$1)(gsub(/i2c-/,"",$1))');do
  echo "Bus #${bus}";
  i2cdetect -y ${bus};
done
