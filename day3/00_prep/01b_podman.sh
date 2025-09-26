#!/bin/bash
set -x
brew install podman kind
sleep 2
# start podman as a mac application
kind create cluster
sleep 2
kubectl config use-context kind-kind
sleep 2
