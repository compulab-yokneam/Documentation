# HAB
* U-Boot
  * ``meta-compulab-hab`` branch to use [imx8-scarthgap-devel](https://github.com/compulab-yokneam/meta-compulab-hab/blob/imx8-scarthgap-devel)
  * Load address
    * [U-Boot HAB Loadaddr](https://github.com/compulab-yokneam/meta-compulab-hab/blob/imx8-scarthgap-devel/recipes-bsp/u-boot/compulab/imx8m/security.cfg#L9)
    * [Grub Kerenl Image Load address](https://github.com/compulab-yokneam/meta-compulab-hab/blob/imx8-scarthgap-devel/recipes-bsp/grub/files/0002-efi-linux-Use-static-kernel-load-address.patch#L21)
  * [hab: efi: Issue authenticate_buffer() on efi image](https://github.com/compulab-yokneam/u-boot-compulab/commit/b1b9ab2546616603ba99ef84d41d2cceb009e128)

* cst-tools
  * ``cst-tools`` branch to use [cst-4.0.0-devel](https://github.com/compulab-yokneam/cst-tools/blob/cst-4.0.0-devel/imx8/README.md)
  * [hab/signed folder layout](https://github.com/compulab-yokneam/cst-tools/blob/cst-4.0.0-devel/imx8/README.md#signed-files-directory-layout)
