# Get fs parameters
* List the contents of the filesystem superblock<pre>tune2fs -l /dev/mmcblk2p2</pre>


# Turn on/off file system options:

* On<pre>tune2fs -O has_journal /dev/mmcblk2p2</pre>

* Off<pre>tune2fs -O ^has_journal /dev/mmcblk2p2</pre>
