#!/bin/bash
#
# https://github.com/kubernetes/examples/tree/master/staging/persistent-volume-provisioning/

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

msg show storage classes:
msg
msg kubectl get storageclass
msg
msg create storage class slow:
msg
msg kubectl apply -f storageclass-slow.yaml
msg
msg kubectl get storageclass
msg
msg hit ENTER to continue
read i

msg create pvc:
msg
msg kubectl get pv
msg kubectl get pvc
msg
msg kubectl apply -f pvc1.yaml
msg
msg kubectl get pv
msg kubectl get pvc
msg
msg hit ENTER to continue
read i

msg delete pvc:
msg
msg kubectl delete pvc pvc1
msg
msg kubectl get pv
msg kubectl get pvc
msg
msg hit ENTER to continue
read i

msg delete storage class:
msg
msg kubectl delete sc slow
msg
msg kubectl get sc
