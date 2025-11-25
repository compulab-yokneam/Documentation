# Yocto CompuLab layer modification manual

|Assumptuion|The CompuLab Yocto BSP environment is already created|
|---|---|

* Prepare build's shell environment:
```
source setup-environment build-compulab-machine
```

* Create a basic modification's layer:
```
bitbake-layers create-layer ../sources/meta-modifications-layer
```

* Add the layer to ``bblayers.conf``:
```
bitbake-layers add-layer ../sources/meta-modifications-layer
```

* linux-compulab developmen process:
```
devtool modify linux-compulab
touch workspace/sources/linux-compulab/README.new
git -C workspace/sources/linux-compulab add README.new
git -C workspace/sources/linux-compulab commit -s -m"Add the README.new file"
devtool update-recipe --append ../sources/meta-modifications-layer linux-compulab
```

* u-boot-compulab developmen process:
```
devtool modify u-boot-compulab
touch workspace/sources/u-boot-compulab/README.new
git -C workspace/sources/u-boot-compulab add README.new
git -C workspace/sources/u-boot-compulab commit -s -m"Add the README.new file"
devtool update-recipe --append ../sources/meta-modifications-layer u-boot-compulab
```

* Browse the meta-modifications-layer created content:
```
tree ../sources/meta-modifications-layer/recipes-kernel/ ../sources/meta-modifications-layer/recipes-bsp/
../sources/meta-modifications-layer/recipes-kernel/
└── linux
    ├── linux-compulab
    │   └── 0001-Add-the-README.new-file.patch
    └── linux-compulab_6.6.52.bbappend
../sources/meta-modifications-layer/recipes-bsp/
└── u-boot
    ├── u-boot-compulab
    │   └── 0001-Add-the-README.new-file.patch
    └── u-boot-compulab_2024.04.bbappend
```
* Remove workspace layer:
```
bitbake-layers remove-layer ${BUILDDIR}/workspace
```
