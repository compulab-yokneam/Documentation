# gst

* gst-launch-1.0 filesrc location=/media/Fergie.mp4 ! qtdemux ! vpudec ! kmssink
* gst-launch-1.0 filesrc location=/media/Fergie.mp4 ! qtdemux ! vpudec ! waylandsink window-width=600 window-height=800
* gst-launch-1.0 filesrc location=/media/Sintel_DivXPlusHD_2Titles_6500kbps.mkv ! matroskademux ! vpudec ! waylandsink window-width=600 window-height=800
