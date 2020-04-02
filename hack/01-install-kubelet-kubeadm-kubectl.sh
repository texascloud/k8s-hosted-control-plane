#!/bin/bash
set -x

apt-get update && apt-get install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update
apt-get install -y --allow-change-held-packages --allow-downgrades kubelet=1.15.4-00 kubectl=1.15.4-00 kubeadm=1.15.4-00
apt-mark hold kubelet kubeadm kubectl
