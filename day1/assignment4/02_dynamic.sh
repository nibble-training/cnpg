#!/bin/bash
set -x

kubectl get pv

PVCNAME=dynamic-pvc

echo "
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ${PVCNAME}
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
  resources:
    requests:
      storage: 5Gi" | kubectl create -f -
sleep 2
kubectl get pvc

PODNAME=hello-node-dynamic-pvc
echo "
---
apiVersion: v1
kind: Pod
metadata:
  name: ${PODNAME}
spec:
  containers:
    - command:
        - /agnhost
        - netexec
        - --http-port=8080
      image: registry.k8s.io/e2e-test-images/agnhost:2.39
      name: agnhost
      volumeMounts:
        - mountPath: /var/www
          name: www
  volumes:
    - name: www
      persistentVolumeClaim:
        claimName: ${PVCNAME}
" | kubectl create -f -
sleep 2
kubectl get pv
