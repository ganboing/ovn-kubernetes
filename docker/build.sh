#!/bin/bash

set -xe

cd "$(dirname "$0")"
G="$(git rev-parse --show-toplevel)"
K="$G/docker/host-daemon"

T="$(mktemp /tmp/ovnkube-XXXXXX)"
trap "{ rm -rf "$T"; }" EXIT

pushd "$G"
git archive master | tar --delete go-controller vagrant docker > "$T"
ls -al "$T"
popd

mv "$T" "$K/ovn-kube.tar"
cd "$K"
docker build --no-cache -t ovnkube-host-daemon .
