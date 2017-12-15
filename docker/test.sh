#!/bin/bash

docker run --rm -it --entrypoint /bin/bash -e TERM=linux \
  -v /opt/ovn-kubernetes:/opt/ovn-kubernetes \
  -v /opt/cni/bin:/host/opt/cni/bin \
  -v /etc/cni/net.d:/host/etc/cni/net.d \
  ovnkube-host-daemon -l
