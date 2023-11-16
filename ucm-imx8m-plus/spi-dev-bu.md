# A new SPI device bring-up
1. Configure an spidev "rohm,dh2228fv" on the required spi bus with the correct cs.<br>
2. Use the spidev_test and perform an input request from the device<br>
  2.1 Make sure that the spidev_test return no error. Go to the step #3<br>
  2.2 the spidev_test failed; make sure that the device connected correctly & fix all connectivity’s issues.<br>
3. Define the real spi device not on the same bus and the cs.<br>
4. Enable the driver that matches the device node compatibility string.<br>
5. If the driver is not found in the kernel source tree, talk the hw provider and ask for the Linux kernel driver source code.<br>
  5.1 Compile the driver in | out the compatible kernel source.<br>
  5.2 Copy the kernel object to the rootfs and load it.<br>
