#!/bin/bash
set -x
kubectl create namespace hello-node
sleep 2
kubectl config set-context --current --namespace=hello-node
sleep 2
kubectl create deployment hello-node --image=registry.k8s.io/e2e-test-images/agnhost:2.39 -- /agnhost netexec --http-port=8080
sleep 2
kubectl get pods -l "app=hello-node"
sleep 2
kubectl scale --replicas=2 deployment/hello-node
sleep 2
kubectl expose deployment hello-node --type=LoadBalancer --port=8080
sleep 2
kubectl port-forward "$(kubectl get pod -l "app=hello-node" -o=name)" 8080
sleep 2
#kubectl port-forward service/hello-node 8080
