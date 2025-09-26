#!/bin/bash
set -x
kubectl get namespaces
sleep 2
kubectl get all --namespace default
sleep 2
kubectl config set-context --current --namespace=kubesystem
sleep 2
kubectl get all
sleep 2
