#!/bin/bash

# TODO: check for existence of "-n" and use that if specified
echo "Defaulting to --all-namespaces"
echo "Using kubeconfig from environment: $KUBECONFIG"

__api_resource=$1
__comparison=$2
__time=$3

# Lame, but necessary cuz of awk not accepting variable substitution for its comparison operator (I couldn't get it to work, pls do help if you think you can)
echo $__time > .time

# Only worrying about 2 kinds of comparisons that awk supports for now since I think they're the most useful: <= and >=
if [ "$__comparison" == ">=" ];then
        printf "NAMESPACE\tNAME\n"
        printf "$(kubectl get $__api_resource --all-namespaces -o go-template --template \
                '{{range .items}}{{.metadata.namespace}}    {{.metadata.name}}    {{.metadata.creationTimestamp}}{{"\n"}}{{end}}' | awk \
                '$3 >= "'$(date -f .time -Ins --utc)'" { print $1,$2 }')"
elif [ "$__comparison" == "<=" ]; then
        printf "NAMESPACE\tNAME\n"
        printf "$(kubectl get $__api_resource --all-namespaces -o go-template --template \
                '{{range .items}}{{.metadata.namespace}}    {{.metadata.name}}    {{.metadata.creationTimestamp}}{{"\n"}}{{end}}' | awk \
                '$3 <= "'$(date -f .time -Ins --utc)'" { print $1,$2 }')"
fi
