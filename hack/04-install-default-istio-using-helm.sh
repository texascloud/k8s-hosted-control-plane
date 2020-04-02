#!/bin/bash
set -x

#echo "Go here and do this first cuz you're using 1.16, then run the commented parts for istio installation after"
#echo "https://github.com/helm/helm/issues/6374#issuecomment-533186177"
#exit 1

# https://riyazmsm.blogspot.com/2018/12/unable-to-install-istio-on-specified.html?view=classic
# Setup helm/tiller/rbac stuff
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-role --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --wait

helm repo add istio.io https://storage.googleapis.com/istio-release/releases/1.3.1/charts/
helm repo update

# Install istio-init
helm install istio.io/istio-init --wait --name istio-init --namespace istio-system

# Install istio default configuration (recommended for production)
# This is going to use NodePort on our bare metal machine cluster for now until we get more IPs
helm install istio.io/istio --wait --name istio --namespace istio-system # --set gateways.istio-ingressgateway.type=NodePort


