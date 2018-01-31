#!/bin/bash

umask 022
shopt -s nullglob
set -ex

source "$(dirname "${BASH_SOURCE[0]}")/common-api.bash"

#fail early while racing with watcher
NODE_SUBNET=$(get_self_subnet)

BIN_NAME=ovn-k8s-cni-overlay
CONF_NAME=10-net.conf
CONF_TEMPLATE=/etc/ovn-cni.conf

HOST_BIN_DIR=/host/opt/cni/bin
HOST_CONF_DIR=/host/etc/cni/net.d
HOST_OVS_CONF_DIR=/host/etc/openvswitch

#identical mount
OVN_V=/opt/ovn-kubernetes

#remove old files
rm -rf $OVN_V/* $HOST_BIN_DIR/$BIN_NAME $HOST_CONF_DIR/$CONF_NAME

#install apiserver ca cert
CACERT="$(get_ca_cert_path)"
cp -f "$CACERT" "$HOST_OVS_CONF_DIR/k8s-ca.crt"

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
ln -snf $TB $HOST_BIN_DIR/$BIN_NAME

#install cni config
TF=$(mktemp -p $HOST_CONF_DIR $CONF_NAME.XXXXXX)
cat $CONF_TEMPLATE | jq '.ipam.subnet = "'$NODE_SUBNET'"' > $TF
#Using mv to atomic operation
mv $TF $HOST_CONF_DIR/$CONF_NAME

trap "{ rm -rf $OVN_V/* $HOST_BIN_DIR/$BIN_NAME $HOST_CONF_DIR/$CONF_NAME; }" EXIT
tail -f /dev/null

exit 1
