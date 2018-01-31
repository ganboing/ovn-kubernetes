#!/bin/bash

shopt -s nullglob
set -xe

cd "$(dirname "$0")"
G="$(git rev-parse --show-toplevel)"
K="$G/docker/host-daemon"

#pushd "$G"
#rm -rf dist
#python2 setup.py sdist
#popd

D=( $G/dist/* )
[ ${#D[@]} -eq 1 ] || exit 1

pushd "$G/go-controller"
make
popd

mkdir -p "$K/wheelhouse"
mv -f "$D" "$K/wheelhouse/"
tar Cczf "$G/go-controller/_output/go/bin" "$K/ovn-go.tar.gz" .

cd "$K"
docker build --no-cache -t ovnkube-host-daemon .
