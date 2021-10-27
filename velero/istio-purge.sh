#!/bin/bash

set -o errexit
set -o pipefail

if [ $# -eq 1 ];
then
    if [ $1 == "hard" ];
    then
        istioctl x uninstall --purge --skip-confirmation
    elif [ $1 == "soft" ];
    then
        istioctl x uninstall -r $(istioctl x revision list | awk '{print $1}' | head -2 | tail -1) --skip-confirmation
    else
        printf "Error: wrong arguments.\nUsage: ./istio-purge.sh <soft || hard>"
        exit 1
    fi
else
    printf "Error: uninstall type is required.\nUsage: ./istio-purge.sh <soft || hard>"
fi