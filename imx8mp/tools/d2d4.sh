#!/bin/bash

work_dir=$(mktemp --directory)
wget -qO - https://github.com/compulab-yokneam/Documentation/raw/refs/heads/master/imx8mp/tools/d2d4.tar.gz | tar -C ${work_dir} -xzf -
cd ${work_dir}/
./run.me 
cd -
rm -rf ${work_dir}
