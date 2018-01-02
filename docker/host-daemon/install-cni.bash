#!/bin/bash

umask 022
shopt -s nullglob
set -ex

source "$(dirname "${BASH_SOURCE[0]}")/common-api.bash"

#fail early while racing with watcher
NODE_SUBNET=$(get_node_subnet)

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
virtualenv -v --no-download --python=python2 $TV
source $TV/bin/activate
#install from local cache
pip install --no-cache-dir --no-index -f /wheelhouse ovn-kubernetes
deactivate

#install cni wapper
TB=$TV/bin/wrapper
touch $TB
chmod +x $TB

cat > $TB << EOF
#!/bin/bash
source $TV/bin/activate
"$TV/bin/\$(basename "\$0")" "\$@"
EOF
ln -snf $TB $CNI_BIN_DIR/$CNI_BIN
ln -snf $TB /bin/ovn-k8s-overlay

#install cni config
TF=$(mktemp -p $CNI_CONF_DIR $CNI_CONF.XXXXXX)
cat $CONF | jq '.ipam.subnet = "'$NODE_SUBNET'"' > $TF
#Using mv to atomic operation
mv $TF $CNI_CONF_DIR/$CNI_CONF

while true; do
sleep 1d
done
