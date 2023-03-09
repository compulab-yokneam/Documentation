#!/bin/bash

grep -ira  . /sys/class/net/*/address | awk -F"net/" '$0=$2'
