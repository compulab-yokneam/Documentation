#!/bin/bash -x

for cmd in s u b;do echo ${cmd} > /proc/sysrq-trigger ; done
