#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/common-api.bash"

if [ "$(get_node_role)" == "MASTER" ]; then
  exec /opt/ovn-go-kube/ovnkube -init-master "$(get_node_name)" -ca-cert "$(get_ca_cert_path)" -token "$(get_token)" -apiserver "$(get_api_server)" -cluster-subnet "$(get_cluster_cidr)" -net-controller
else
  exit 1
fi
