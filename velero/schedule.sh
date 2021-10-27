#!/bin/bash
set -o errexit
set -o pipefail

if [ $# -eq 2 ];
then
    SCHEDULE_NAME=$1
    if [ $2 == "production" ];
    then
        CRON_TAB="0 3 * * *"
    elif [ $2 == "staging" ]
    then
        CRON_TAB="0 3 * * 5"
    else
        printf "Error: stage is required!!\nUsage: ./schedule.sh <SCHEDULE_NAME> <production/staging>"
        exit 1
    fi;
else
    printf "Error: stage is required!!\nUsage: ./schedule.sh <SCHEDULE_NAME> <production/staging>"
    exit 1
fi

velero create schedule "$SCHEDULE_NAME" \
    --schedule "$CRON_TAB" \
    --ttl "168h0m0s" \
    --include-cluster-resources=true \
    --include-resources "*" \
    --exclude-namespaces kube-public,kube-node-lease,kube-system,velero \
    --exclude-resources flowschemas.flowcontrol.apiserver.k8s.io,prioritylevelconfigurations.flowcontrol.apiserver.k8s.io \
