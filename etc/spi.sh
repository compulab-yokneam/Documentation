#!/bin/bash -e

dd if=/dev/urandom of=/tmp/test.file bs=4K count=1 &>/dev/null

spi_max_speed_hz=${1:-12000000}
cnt=${2:-256}

intro() {
    spidev_test -D /dev/spidev0.0 -s ${spi_max_speed_hz} -v -p "Start tranferring $((4096*${cnt})) bytes with with ${spi_max_speed_hz} Hz speed"
}

spi_file_transfer() {
while [ $((cnt--)) -gt 0 ];do
    spidev_test -D /dev/spidev0.0 -s ${spi_max_speed_hz} -i /tmp/test.file -o /tmp/test.ofile &>/dev/null
done
}

intro
time spi_file_transfer
