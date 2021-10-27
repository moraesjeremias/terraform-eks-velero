#!/bin/bash
set -o errexit
set -o pipefail

if [ $# -eq 1 ];
then
    BACKUP_NAME=$1
else
    printf "Error: BACKUP_NAME is required.\nUsage: ./restore.sh <BACKUP_NAME>"
    exit 1
fi

kubectl patch backupstoragelocation default \
    --namespace velero \
    --type merge \
    --patch '{"spec":{"accessMode":"ReadOnly"}}'

kubectl apply -f "https://raw.githubusercontent.com/GoogleCloudPlatform/marketplace-k8s-app-tools/master/crd/app-crd.yaml"

velero restore create $BACKUP_NAME \
    --from-backup $BACKUP_NAME \
    --include-cluster-resources \
    --include-resources="*" \
    --exclude-namespaces kube-public,kube-node-lease,kube-system,velero \
    --exclude-resources flowschemas.flowcontrol.apiserver.k8s.io,prioritylevelconfigurations.flowcontrol.apiserver.k8s.io \
    --wait

kubectl patch backupstoragelocation default \
    --namespace velero \
    --type merge \
    --patch '{"spec":{"accessMode":"ReadWrite"}}'