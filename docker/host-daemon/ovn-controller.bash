#!/bin/bash

set -xe

source "$(dirname "${BASH_SOURCE[0]}")/ovs-common.inc"

exec ovn-controller "unix:$DBSOCK" -vconsole:info
