#!/bin/bash -x

function get_n_install() {

    docker+="https://github.com/compulab-yokneam/bin/raw/docker/docker/docker-moby-cli_24.0.5+git00e46f85f6e46bb4b02c33da253f901c473794e9-r0_arm64.deb "
    docker+="https://github.com/compulab-yokneam/bin/raw/docker/docker/docker-moby_24.0.5+git00e46f85f6e46bb4b02c33da253f901c473794e9-r0_arm64.deb "
    dir=$(mktemp -d)

    for _docker in ${docker};do
        wget --directory-prefix ${dir} ${_docker}
    done

    dpkg -i ${dir}/*

    rm -rf ${dir}

}

function rem_n_cleanup() {
    apt-get purge docker-ce docker-ce-cli
}

function fix_n_go() {
    sed -i '/INTERCEPT_DIR/d' /var/lib/dpkg/info/grub-efi-env.postinst
}

fix_n_go
rem_n_cleanup
get_n_install
