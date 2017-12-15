#!/bin/bash

K=/var/run/secrets/kubernetes.io/serviceaccount

[ -a $K ] || exit 1

curl -sS --cacert $K/ca.crt -H "Authorization: Bearer $(cat $K/token)" $K8S_API_SERVER/$1
