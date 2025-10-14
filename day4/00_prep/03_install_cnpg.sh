#!/bin/bash
set -x
kubectl cnpg install generate | kubectl create -f -
sleep 2
kubectl get all --namespace cnpg-system
sleep 2
kubectl get pod --namespace cnpg-system -w
sleep 2
