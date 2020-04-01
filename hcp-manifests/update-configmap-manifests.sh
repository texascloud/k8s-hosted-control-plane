#!/bin/bash

kubectl -n testing delete configmap k3s-server-manifests
kubectl -n testing delete configmap k3s-server-scripts

kubectl -n testing create configmap k3s-server-manifests --from-file=/root/k3s-server-deployment/manifests
kubectl -n testing create configmap k3s-server-scripts --from-file=/root/k3s-server-deployment/scripts
