#!/bin/bash -x

for f in iwlwifi-ty-a0-gf-a0-62.ucode iwlwifi-ty-a0-gf-a0-63.ucode iwlwifi-ty-a0-gf-a0-66.ucode iwlwifi-ty-a0-gf-a0-67.ucode iwlwifi-ty-a0-gf-a0.pnvm;
do
  rm -rf /lib/firmware/$f;
done
