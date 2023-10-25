# Modify the linux-compulab using devtool


## Modify the source for an existing recipe; create the source tree snapshot:
```
devtool modify linux-compulab
```
## Goto the source directory
```
cd ${BUILDDIR}/workspace/sources/linux-compulab$
```
## Commit the changes:
```
git commit -s -m"compulab: dts: Update ucm-imx8m-plus.dts" arch/arm64/boot/dts/compulab/ucm-imx8m-plus.dts
```

## Apply changes from external source tree to recipe:

### Option #1) Using devtool:
```
devtool  update-recipe linux-compulab
````

### Option #2) Issue all steps manually:

* Create a patch and save it in the recipe's patches folder:
```
git format-patch -n -o /path/to/build-ucm-imx8m-plus/../sources/meta-bsp-imx8mp/recipes-kernel/linux/compulab/5.15.71/imx8mp HEAD~1
/path/to/build-ucm-imx8m-plus/../sources/meta-bsp-imx8mp/recipes-kernel/linux/compulab/5.15.71/imx8mp/0001-compulab-dts-Update-ucm-imx8m-plus.dts.patch
```

* Update the recipe's file:
```
vi /path/to/build-ucm-imx8m-plus/../sources/meta-bsp-imx8mp/recipes-kernel/linux/compulab/5.15.71/imx8mp.inc
...
```

* Make sure that the changes are there:
```
git -C /path/to/build-ucm-imx8m-plus/../sources/meta-bsp-imx8mp/ diff

diff --git a/recipes-kernel/linux/compulab/5.15.71/imx8mp.inc b/recipes-kernel/linux/compulab/5.15.71/imx8mp.inc
index a44b5fb..0b5273c 100644                                                      
--- a/recipes-kernel/linux/compulab/5.15.71/imx8mp.inc                             
+++ b/recipes-kernel/linux/compulab/5.15.71/imx8mp.inc                          
@@ -1,6 +1,7 @@                                                                    
 SRC_URI += " \                                                                    
        file://defconfig \                                                         
        file://linux-headers.cfg \                                                 
+       file://0001-compulab-dts-Update-ucm-imx8m-plus.dts.patch \                 
 "                                                                                 
 SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'linux-rt', 'file://rt.patch file://rt.cfg', '', d)}"

```
                                                                                   
* Make sure that the recipe folder contains a modified file an new file:
```
git -C /path/to/build-ucm-imx8m-plus/../sources/meta-bsp-imx8mp/ status

On branch kirkstone-2.2.0                                                          
Your branch is up to date with 'compulab/kirkstone-2.2.0'.                         
                                                                                   
Changes not staged for commit:                                                     
  (use "git add <file>..." to update what will be committed)                       
  (use "git checkout -- <file>..." to discard changes in working directory)        
                                                                                
        modified:   recipes-kernel/linux/compulab/5.15.71/imx8mp.inc               
                                                                                   
Untracked files:                                                                   
  (use "git add <file>..." to include in what will be committed)                   
                                                                                   
        recipes-kernel/linux/compulab/5.15.71/imx8mp/0001-compulab-dts-Update-ucm-imx8m-plus.dts.patch
                                                                                   
no changes added to commit (use "git add" and/or "git commit -a")

```
