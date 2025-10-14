#!/bin/bash
set -x
kubectl create namespace "${USER}"
sleep 2
kubectl config set-context --current --namespace "${USER}"
sleep 2

echo "
---
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: example-1
spec:
  enableSuperuserAccess: true
  imageName: ghcr.io/cloudnative-pg/postgresql:17
  postgresql:
    parameters:
      max_connections: '2000'
    pg_hba:
      # default: host all all all <default-authentication-method>
      - hostssl app app 10.244.0.0/16 md5
  storage:
    size: 20Gi
  walStorage:
    size: 10Gi
  resources:
    requests:
      memory: '500Mi'
      cpu: '600m'
    limits:
      memory: '500Mi'
      cpu: '600m'
  backup:
    barmanObjectStore:
      destinationPath: https://nblstorageaccount.blob.core.windows.net/azureuser
      azureCredentials:
        storageAccount:
          name: azure-creds
          key: AZ_STORAGE_ACCOUNT
        storageSasToken:
          name: azure-creds
          key: AZ_SAS_TOKEN
      wal:
        maxParallel: 8
  managed:
    roles:
      - name: my-user
        ensure: present
        comment: My manually added user
        login: true
        superuser: true
" | kubectl apply -f -
sleep 2
kubectl get pod -w
