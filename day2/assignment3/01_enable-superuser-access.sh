#!/bin/bash
set -x
kubectl get secret
kubectl apply -f 01_*.yaml
sleep 2
kubectl get secret
sleep 2
kubectl get secret example-1-superuser -o yaml
sleep 2
kubectl get secret example-1-superuser -o=jsonpath='{.data.password}' | base64 -d
