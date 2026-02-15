# Development environment how to:

* Step #1
```
mkdir edge-ai
cd edge-ai
bash <(curl -fsSL https://raw.githubusercontent.com/compulab-yokneam/edge-ai-linux/devel/scripts/runme.sh)
```

* Step #2
```
curl -fsSL https://github.com/compulab-yokneam/compulab-l4t/archive/refs/heads/Linux_for_Tegra.tar.gz | tar -C ${L4T_ROOT} --strip-components=1 -xvz
```

* Step #3
```
source compulab-l4t.env
**********************************
* devshell       -- development shell
* simple_shell   -- user shell
* mfg_deployment -- flashing bootloader
***********************************
devshell
```
