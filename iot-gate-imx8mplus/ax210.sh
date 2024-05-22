#!/bin/bash

ACTIVE_DIR=/lib/firmware
HIDDEN_DIR=/lib/firmware/hidden

FIRMWARE_FILE=" \
        iwlwifi-ty-a0-gf-a0-62.ucode \
        iwlwifi-ty-a0-gf-a0-63.ucode \
        iwlwifi-ty-a0-gf-a0-66.ucode \
        iwlwifi-ty-a0-gf-a0-67.ucode \
        iwlwifi-ty-a0-gf-a0.pnvm \
"

_move_file() {
        [[ -f "${file:-/x/y/z}" ]] || return 0
        mkdir ${dest} -p
        mv ${file} ${dest}/
}

move_files() {
        for f in ${FIRMWARE_FILE};
        do
          [[ -f ${source_dir}/$f ]] && file=${source_dir}/$f dest=${destination_dir} _move_file
        done
}

DIRECTION=${DIRECTION:-0}

[[ ${DIRECTION} -eq 0 ]] && source_dir=${ACTIVE_DIR} destination_dir=${HIDDEN_DIR} || source_dir=${HIDDEN_DIR} destination_dir=${ACTIVE_DIR}

source_dir=${source_dir} destination_dir=${destination_dir} move_files
