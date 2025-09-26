#!/bin/bash
kubectl create secret generic --type "Opaque" example-1-my-user --dry-run=client --from-literal="password=my-secret-password" --from-literal="username=my-user" --dry-run='none'
