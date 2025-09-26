#!/bin/bash
set -x
#kubectl delete deployment/hello-node service/hello-node
kubectl config set-context --current --namespace=default
sleep 2
kubectl delete namespace hello-node
sleep 2
