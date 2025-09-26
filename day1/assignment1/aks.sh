#!/bin/bash
set -x
az group create --location uksouth --resource-group nbl-training
sleep 2
az aks create -g nbl-training -n nbl-training-1 --enable-cluster-autoscaler --min-count 2 --max-count 5
sleep 2
az aks get-credentials --resource-group nbl-training --name nbl-training-1 --overwrite-existing
sleep 2
