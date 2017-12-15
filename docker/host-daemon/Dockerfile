FROM vmware/photon:2.0

MAINTAINER Bo Gan <ganb@vmware.com>

USER root

RUN tdnf install --refresh -y -q python-pip python-virtualenv git jq

COPY entrypoint.bash install-cni.bash /
COPY ovn-cni.conf /etc/
RUN mkdir -p /usr/src/ovn-kubernetes && cd /usr/src/ovn-kubernetes && git clone https://github.com/openvswitch/ovn-kubernetes .
#ADD ovn-kube.tar /usr/src/ovn-kubernetes/

ENTRYPOINT /entrypoint.bash
