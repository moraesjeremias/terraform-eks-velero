#!/bin/bash
set -o errexit
set -o pipefail

if [ $# -eq 1 ];
then
    BACKUP_NAME=$1
else
    printf "Error: BACKUP_NAME is required.\nUsage: ./backup.sh <BACKUP_NAME>"
    exit 1
fi

velero backup create $BACKUP_NAME \
    --include-cluster-resources=true \
    --include-resources "*" \
    --exclude-namespaces kube-public,kube-node-lease,kube-system,velero \
    --exclude-resources flowschemas.flowcontrol.apiserver.k8s.io,prioritylevelconfigurations.flowcontrol.apiserver.k8s.io \
    --wait
