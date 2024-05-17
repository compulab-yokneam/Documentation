# Developing with Qt on CompuLab platforms

## Micledore-2.2.0
* Download and install the SDK using this [manual](https://github.com/compulab-yokneam/meta-bsp-imx8mp/blob/mickledore-2.2.0/Documentation/sdk.md)
* Download Qt examples from this [location](https://drive.google.com/file/d/1YYQhahWWlmjkmBet4fP9jJESbWqv03WK/view?usp=drive_link)
* Extract the Qt examples:
```
mkdir ~/qt/ && cd ~/qt
tar -xf /path/to/qt-examples.tar.bz2
cd Qt/Examples
```

* Issue qmake ..
```
cd Qt-6.6.3/opengl/hellogles3/
qmake -config release
make -j 8
```

* Copy the created binary to the target machine and make sure that it works.
