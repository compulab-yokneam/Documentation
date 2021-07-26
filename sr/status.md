# System Ready Status

## Input

https://git.linaro.org/people/paul.liu/systemready/build-scripts.git

## Build
* Original

|Procedire|status|
|---|---|
|git clone https://git.linaro.org/people/paul.liu/systemready/build-scripts.git|okay|
|Run download_everything.sh|okay|
|Run build_everything.sh|Failed at atf build|

* Aternative

Due to the fact that we was not able to build the atf binaries using the 'original build procedure' we tried  to follow the
https://git.linaro.org/people/paul.liu/systemready/build-scripts.git/tree/docs/iotgateimx8_building_running.md

Unfortunately we ran into an issue at #104-110 lines.

## Status

As of now we failed on creating flash.bin image on both procedure.

## What we would like to have

A formal step-by-step procedure to follow that can be issued w/out any user interactions

|NOTE|All provided scripts require the build environment modification to be applied 1-st.|
|---|---|

## What we have as of now

* https://github.com/compulab-yokneam/meta-compulab-sr

This meta-layer allows:
1) to build the 2021.07 system ready U-boot;
2) to produce a flash.bin with NXP provided atf and optee.

The produced flash.bin image was used for running:

http://ftp.nl.debian.org/debian/dists/buster/main/installer-arm64/current/images/netboot/

As a result we have Debian 11 Sid installed on the internal media. This distro was updated with a Linix kernel produced by:

https://git.linaro.org/people/paul.liu/systemready/build-scripts.git/tree/docs/iotgateimx8_building_running.md#n149
