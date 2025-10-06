#!/bin/bash

kubectl create configmap pg-dump-scripts \
	--from-file="upload.py=upload.py"

kubectl create -f pg-dump-pod.yaml
