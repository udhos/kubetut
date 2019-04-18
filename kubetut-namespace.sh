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
msg
msg kubectl get namespace
msg
msg list pods from all namespace:
msg
msg kubectl get pods --all-namespaces
msg
msg list pods from specific namespace:
msg
msg kubectl get pods -n kube-system
msg
msg hit ENTER to continue
read i

