#!/bin/bash

#[ -z "$OVN_K8S_API_SERVER" ] && exit 2

KUBE_SECRETS_DIR=/var/run/secrets/kubernetes.io/serviceaccount
API_GETTER="$(dirname "${BASH_SOURCE[0]}")/kubeapi-get.bash"

get_ca_cert_path(){
  [ -a "$KUBE_SECRETS_DIR/ca.crt" ] || return 1
  echo "$KUBE_SECRETS_DIR/ca.crt"
}

get_token(){
  set -e
  cat "$KUBE_SECRETS_DIR/token"
}

get_node_name(){
  [ -z "$OVN_K8S_NODE_NAME" ] && return 1
  echo "$OVN_K8S_NODE_NAME"
}

get_cluster_cidr(){
  [ -z "$OVN_K8S_CLUSTER_CIDR" ] && return 2
  echo "$OVN_K8S_CLUSTER_CIDR"
}

get_api_server(){
  [ -z "$OVN_K8S_API_SERVER" ] && return 1
  echo "$OVN_K8S_API_SERVER"
}

get_node_subnet(){
  set -e
  local N
  #fail early
  N="$(get_node_name)"
  local S
  #jq will return 0 on a empty input
  S="$( "$API_GETTER" "api/v1/nodes/$N" | jq -er '.metadata.annotations["ovn_host_subnet"]')"
  [ -z "$S" ] && return 3
  echo $S
}

get_node_role() {
  set -e
  local N
  #fail early
  N="$(get_node_name)"
  local L
  L="$( "$API_GETTER" "api/v1/nodes/$N" | jq -e '.metadata.labels')"
  [ -z "$L" ] && return 4
  if echo "$L" | jq -e '."node-role.kubernetes.io/master"' > /dev/null; then
    echo MASTER
  else
    echo WORKER
  fi
}
