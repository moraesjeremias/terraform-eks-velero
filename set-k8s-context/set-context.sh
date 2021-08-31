#!/bin/bash
set -o errexit
set -o pipefail

if [ $# -eq 3 ];
then
    GCP_PROJECT=$1
    KUBERNETES_CLUSTER_NAME=$2
    GCP_ZONE_LOCATION=$3

else
    printf "$1\n$2\n$3\n"
    printf "Error: Missing Arguments!!.\nUsage: ./set-context.sh <GCP_PROJECT> <TERRAFORM_OUT_K8S_CLUSTER_NAME> <TERRAFORM_OUT_ZONE>"
    exit 1
fi

gcloud container clusters get-credentials $(terraform output -raw $KUBERNETES_CLUSTER_NAME) \
--zone $(terraform output -raw $GCP_ZONE_LOCATION) \
--project $GCP_PROJECT
