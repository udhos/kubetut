#!/bin/bash
#
# https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

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

msg show statefulsets:
msg
msg kubectl get statefulset,pv,pvc,pod,service
msg
msg create statefulset:
msg
msg kubectl create -f statefulset.yaml
msg
msg kubectl get statefulset,pv,pvc,pod,service
msg
msg hit ENTER to continue
read i

msg delete statefulset:
msg
msg kubectl delete -f statefulset.yaml
msg
msg kubectl get statefulset,pv,pvc,pod,service
msg
msg hit ENTER to continue
read i

msg delete pvcs:
msg
msg kubectl delete persistentvolumeclaim/www-web-0
msg kubectl delete persistentvolumeclaim/www-web-1
msg kubectl delete persistentvolumeclaim/www-web-2
msg
msg kubectl get statefulset,pv,pvc,pod,service
msg
msg hit ENTER to continue
read i

