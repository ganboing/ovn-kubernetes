FROM vmware/photon:2.0

MAINTAINER Bo Gan <ganb@vmware.com>

USER root

ENV PYTHONDONTWRITEBYTECODE yes

RUN tdnf install --refresh -y -q python-pip python-virtualenv openvswitch ovn-common git jq iproute2 strace && tdnf clean all

COPY entrypoint.bash install-cni.bash kubeapi-get.bash common-api.bash /root/
COPY ovn-cni.conf /etc/
#RUN mkdir -p /usr/src/ovn-kubernetes
#cd /usr/src/ovn-kubernetes && git clone --depth=1 https://github.com/openvswitch/ovn-kubernetes .
#ADD ovn-kube.tar /usr/src/ovn-kubernetes

COPY wheelhouse /wheelhouse
RUN pip download -d /wheelhouse -f /wheelhouse ovn-kubernetes

#RUN mkdir -p /wheelhouse && pip download -d /wheelhouse --no-cache-dir /usr/src/ovn-kubernetes
ADD ovn-go.tar.gz /opt/ovn-go-kube/

WORKDIR /root
ENTRYPOINT /entrypoint.bash
