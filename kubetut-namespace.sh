#!/bin/bash
#
# 

me=$(basename "$0")

msg() {
    echo >&2 "$me:" "$@"
}

die() {
	msg "$@"
	exit 1
}

run() {
	msg run: "$@"
}

msg list namespaces:
msg kubectl get namespaces --show-labels
msg
msg list pods from all namespace:
msg kubectl get pods --all-namespaces
msg
msg list pods from specific namespace:
msg kubectl get pods -n kube-system
msg
msg "get detailed information for namespace 'default':"
msg kubectl describe namespaces default
msg
msg "create namespace 'lab':"
msg kubectl create -f namespace-lab.yaml
msg
msg "get detailed information for namespace 'lab':"
msg kubectl describe namespaces lab
msg
msg hit ENTER to continue
read i

msg create a context pointing to cluster and namespace:
msg 'current_context=$(kubectl config current-context)'
msg 'echo $current_context'
msg 'kubectl config set-context clab --namespace=lab --cluster=$current_context --user=$current_context'
msg
msg check the new context:
msg kubectl config view
msg
msg switch to new context clab:
msg kubectl config use-context clab
msg
msg check current context:
msg kubectl config current-context
msg
msg === kubectl commands here will default to cluster/namespace from context clab ===
msg
msg return to previous context:
msg 'kubectl config use-context $current_context'
msg
msg delete context clab:
msg kubectl config delete-context clab
msg
msg delete namespace lab:
msg kubectl delete namespaces lab
msg
msg hit ENTER to continue
read i

