#  How use gstreamer to play/stream youtube video


* Source<br>https://forum.manjaro.org/t/how-use-gstreamer-to-play-stream-youtube-video-in-1080-60-or-higher-with-audio/175760

* Tool
```
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux_aarch64 -o /usr/local/bin/youtube-dl
chmod a+rx /usr/local/bin/youtube-dl
```  

* Command 
```
gst-launch-1.0 souphttpsrc is-live=true location="$(yt-dlp --format "best[ext=mp4][height<=?1080][fps<=?60][protocol=https]" --get-url https://www.youtube.com/watch?v=7PIji8OubXU)" ! qtdemux name=demuxer  demuxer. ! queue ! avdec_h264 ! autovideosink  demuxer.audio_0 ! queue ! avdec_aac ! audioconvert ! audioresample ! autoaudiosink
```
