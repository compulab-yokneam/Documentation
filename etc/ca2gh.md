# codeaurora to github

## kirkstone
* Download the tar ball from this location:
[ca2gh](https://drive.google.com/drive/folders/1gcEGkO1mexa_IDxiPLg-8E1pB8epWJFw)

* Deploy it this way:
```
tar -C  ${BUILDDIR}/../sources/meta-compulab -xf /path/to/recipes-github.tar.bz2
```

## zeus
* nxp-demo-experience

Add these lines to the `conf/local.conf`
```
NXP_DEMO_SRC = "git://github.com/nxp-imx-support/nxp-demo-experience.git;protocol=https"
NXP_DEMO_LIST_SRC = "git://github.com/nxp-imx-support/nxp-demo-experience-demos-list.git;protocol=https"
```

