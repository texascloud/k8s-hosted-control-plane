#!/bin/bash
set -x

# My POD CIDR is in /root/init-defaults.yaml for kubeadm init command
echo "POD CIDR is in /root/kubeadm-init.yaml"

# curl https://docs.projectcalico.org/v3.9/manifests/calico.yaml -O
# set -i -e "s?10.244.0.0/16?10.20.0.0/16?g" calico.yaml

# The current calico.yaml file in this directory has had its POD CIDR changed already
kubectl apply -f calico.yaml
