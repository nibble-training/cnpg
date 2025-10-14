#!/bin/bash

kubectl create configmap pg-dump-scripts \
  --from-file="download.py=download.py" \
  --from-file="upload.py=upload.py"
