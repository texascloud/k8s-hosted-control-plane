#!/bin/sh
set -xe

__kubeconfig=$1

while [[ ! -f "$__kubeconfig" ]]; do
    echo "$__kubeconfig not found; sleeping 10s"
    sleep 10
done

echo "$__kubeconfig found!"

__mp="management-plane"

# Set up necessary context to talk to the management plane via a serviceaccount token
kubectl config set-cluster $__mp --server=https://kubernetes.default --certificate-authority=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
kubectl config set-context $__mp --cluster=$__mp
kubectl config set-credentials $__mp --token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
kubectl config set-context $__mp --user=$__mp
kubectl config use-context $__mp

# TODO: REMOVE, only for testing purposes. We shouldn't need to delete this normally
# Delete this real quick please
# kubectl delete secret k3s-serving --ignore-not-found=true
# kubectl delete secret hcp-admin-kubeconfig --ignore-not-found=true

kubectl config set-cluster default --server=https://hcp.testing.svc.cluster.local:6443

# Strip the namespace field from the secret so when we apply it, our namespace is filled in
# That way we never need to worry about what namespace this Pod is running in for this script, or use funky kustomize stuff
# TODO: Strip out resourceversion field so we can apply without deleting
kubectl --context default --kubeconfig $__kubeconfig get secrets -n kube-system k3s-serving -o yaml |
sed "s/namespace: kube-system//" |
sed 's/.*resourceVersion: .*//' |
sed 's/.*uid: .*//' |
kubectl apply -f -

# Below is only useful during dev
# kubectl create secret generic hcp-admin-kubeconfig --from-file=$__kubeconfig

exit 0
