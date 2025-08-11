# Prerequisites
* Download the mediamtx server for the platform from this page https://github.com/bluenviron/mediamtx/releases
```
wget --quiet -O - https://github.com/bluenviron/mediamtx/releases/download/v1.13.1/mediamtx_v1.13.1_linux_arm64.tar.gz | sudo tar -C /usr/local/bin -xzf -
```
* Make it run:
```
/usr/local/bin/mediamtx &>/dev/null &
```
# Host
```
gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw,width=640,height=480 ! x264enc speed-preset=veryfast tune=zerolatency bitrate=800 ! rtspclientsink location=rtsp://192.168.166.19:8554/test
```
# Client
```
gst-launch-1.0  rtspsrc location=rtsp://192.168.166.19:8554/test latency=0 ! decodebin ! autovideosink
```
