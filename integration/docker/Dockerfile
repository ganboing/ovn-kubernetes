FROM vmware/photon:2.0

MAINTAINER Bo Gan <ganb@vmware.com>

USER root

ENV PYTHONDONTWRITEBYTECODE yes

RUN tdnf install --refresh -y -q PyYAML openvswitch ovn-common ovn-host ovn-central git jq iproute2 strace && tdnf clean all

#RUN mkdir -p /usr/src/ovn-kubernetes
#cd /usr/src/ovn-kubernetes && git clone --depth=1 https://github.com/openvswitch/ovn-kubernetes .
#ADD ovn-kube.tar /usr/src/ovn-kubernetes

#COPY wheelhouse /wheelhouse
#RUN pip download -d /wheelhouse -f /wheelhouse ovn-kubernetes

#RUN mkdir -p /wheelhouse && pip download -d /wheelhouse --no-cache-dir /usr/src/ovn-kubernetes
ADD ovn-go.tar.gz /opt/ovn-go-kube/

COPY entrypoint.bash install-cni.bash kubeapi.bash common-api.bash go-init-master.bash go-init-node.bash ovsdb.bash ovs-vswitchd.bash ovn-controller.bash ovs-common.inc ovnnb-db.bash ovnsb-db.bash ovn-northd.bash ovn-central-common.inc /root/
COPY ovn-cni.conf /etc/

WORKDIR /root
ENTRYPOINT /root/entrypoint.bash
