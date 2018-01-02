#!/bin/bash

KUBE_SECRETS_DIR=/var/run/secrets/kubernetes.io/serviceaccount

[ -a $K ] || exit 1

curl -sS --cacert $KUBE_SECRETS_DIR/ca.crt -H "Authorization: Bearer $(cat $KUBE_SECRETS_DIR/token)" $OVN_K8S_API_SERVER/$1
