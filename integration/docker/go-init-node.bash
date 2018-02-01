#!/bin/bash

set -ex

source "$(dirname "${BASH_SOURCE[0]}")/common-api.bash"

if [ "$(get_node_role)" == "worker" ]; then
  /opt/ovn-go-kube/ovnkube -init-node "$(get_node_name)" -ca-cert "$(get_ca_cert_path)" -token "$(get_token)" -apiserver "$(get_api_server)" -cluster-subnet "$(get_cluster_cidr)"
  sleep 1d
else
  exit 1
fi
