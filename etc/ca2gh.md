# codeaurora to github

* Add following lines to `conf/local.conf`

```
# opencv
OPENCV_SRC = "git://github.com/nxp-imx/opencv-imx.git;protocol=https;branch=master"

# sigma-dut
SRC_URI:remove:sigma-dut = "git://source.codeaurora.org/quic/la/platform/vendor/qcom-opensource/wlan/utils/sigma-dut;protocol=https;branch=github-qca/master;"
SRC_URI:append:sigma-dut = "git://github.com/qca/sigma-dut.git;protocol=https;branch=master;"
```
