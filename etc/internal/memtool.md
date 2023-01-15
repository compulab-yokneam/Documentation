# Memtool how to

* [TRM](http://192.168.11.170/Devel/Work/imx8mp/doc/iMX8M_Plus/Reference/iMX_8M_Plus_RM_RevD.pdf)

* Download
```
mkdir /opt/bin
cd /opt/bin
wget http://192.168.11.170/Devel/Work/imx8/tools/memtool
chmod a+x memtool
```

*  Read
```
./memtool -32 0x303302F8H 1
```

*  Write
```
./memtool -32 0x303302F8H=0x106
```
