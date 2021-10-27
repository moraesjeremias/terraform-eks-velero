#!/bin/bash
set -o errexit
set -o pipefail

if [ $# -eq 2 ];
then
    BUCKET=$1
    SERVICE_ACC_PATH=$2
else
    printf "Error: BUCKET is required.\nUsage: ./install.sh <BUCKET> <SERVICE_ACC_PATH>"
    exit 1
fi

velero install \
    --provider gcp \
    --plugins velero/velero-plugin-for-gcp:v1.2.0 \
    --bucket $BUCKET \
    --secret-file $SERVICE_ACC_PATH \
    -o yaml