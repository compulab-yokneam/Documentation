#!/bin/bash

set -e

clean_up() {
        rm -rf ${WGET_FILE_LOCATION}
}

PROJECT_VERSION=${CL_VERSION:-5.15.32}
PROJECT_NAME="linux-compulab"
SRC_URI="https://github.com/compulab-yokneam/${PROJECT_NAME}/archive/refs/heads/${PROJECT_NAME}_v${PROJECT_VERSION}.zip"
WGET_FILE_LOCATION=$(mktemp --directory)
PROJECT_SRC_DIR=/usr/src

kernel_wget() {
        wget -P ${WGET_FILE_LOCATION} ${SRC_URI}
        unzip -d ${PROJECT_SRC_DIR} ${WGET_FILE_LOCATION}/${PROJECT_NAME}_v${PROJECT_VERSION}.zip
        cd ${PROJECT_SRC_DIR}/${PROJECT_NAME}-${PROJECT_NAME}_v${PROJECT_VERSION}
}

trap clean_up EXIT

kernel_wget
