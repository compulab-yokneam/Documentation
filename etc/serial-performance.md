# Serial Port Performance test

## Loopback performance test

* Short RTX & TXD

* Configure a tty device
Use a factor value in order to increase the device baud rate. The factor value depends on the platform port specification.
The max available value in this test was 3.
```
factor=0
stty -F /dev/ttyLP1 clocal -icanon -onlcr -iexten -echo -echoe -echok -echoctl -echok $((115200 << ${factor}))
```

* Open up two terminal windows:
The status of the 2-nd terminal shows the true port throughput.

|1-st terminal|2-nd terminal|
|----|----|
|dd if=/dev/ttyLP1 of=/dev/null bs=16 status=progress|dd if=/dev/zero of=/dev/ttyLP1 bs=16 status=progress|
