#!/bin/bash

umask 022
shopt -s nullglob
set -ex

BIN=ovn-k8s-cni-overlay
CONF=/etc/ovn-cni.conf

CNI_BIN_DIR=/host/opt/cni/bin
CNI_CONF_DIR=/host/etc/cni/net.d
OVN_V=/opt/ovn-kubernetes
SRC=/usr/src/ovn-kubernetes

CNI_BIN=ovn_cni
CNI_CONF=10-net.conf

#remove old files
rm -rf $OVN_V/* $CNI_BIN_DIR/$CNI_BIN $CNI_CONF_DIR/$CNI_CONF

#install virtualenv
TV=$(mktemp -dp $OVN_V venv-XXXXXX)
virtualenv -v $TV
source $TV/bin/activate
pip install $SRC
deactivate

#install cni wapper
TB=$(mktemp -p $CNI_BIN_DIR $CNI_BIN.XXXXXX)
chmod +x $TB

cat > $TB << EOF
#!/bin/bash
source $TV/bin/activate
ovn-k8s-cni-overlay "\$@"
EOF
mv $TB $CNI_BIN_DIR/$CNI_BIN

#install cni config
TF=$(mktemp -p $CNI_CONF_DIR $CNI_CONF.XXXXXX)
cat $CONF | jq '.ipam.subnet = "'192.168.1.0/24'"' > $TF
mv $TF $CNI_CONF_DIR/$CNI_CONF

while true; do
sleep 1d
done
