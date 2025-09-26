#!/bin/bash
set -x
kubectl create namespace "${USER}"
sleep 2
kubectl config set-context --current --namespace "${USER}"
sleep 2

echo "
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: example-1
spec:
  imageName: ghcr.io/cloudnative-pg/postgresql:17

  storage:
    size: 10Gi
  resources:
    requests:
      memory: '1Gi'
      cpu: '500m'
    limits:
      memory: '1Gi'
      cpu: '500m'
" | kubectl apply -f -
sleep 2
kubectl get pod -w
