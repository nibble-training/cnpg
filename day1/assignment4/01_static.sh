#!/bin/bash
set -x
kubectl get sc
sleep 2

PVNAME=static-pv
PVACCESSMODE=ReadWriteOnce

echo "
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: ${PVNAME}
spec:
  storageClassName: standard
  accessModes:
    - ${PVACCESSMODE}
  capacity:
    storage: 2Gi
  hostPath:
    path: /www/" | kubectl create -f -
sleep 2
kubectl get pv
sleep 2

PVCNAME="static-pvc"
echo "
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ${PVCNAME}
spec:
  volumeName: ${PVNAME}
  accessModes:
    - ${PVACCESSMODE}
  resources:
    requests:
      storage: 1Gi" | kubectl create -f -
sleep 2
kubectl get pvc
sleep 2
PODNAME=hello-node-with-static-pvc
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
kubectl get pv
