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
msg kubectl create -f storageclass-slow.yaml
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
msg kubectl create -f pvc1.yaml
msg
msg kubectl get pv
msg kubectl get pvc
msg
msg hit ENTER to continue
read i

msg create a pod to use the pvc:
msg 
msg kubectl create -f pod-pvc1.yaml
msg
msg inspect the pod:
msg
msg kubectl get pod -oyaml
msg
msg hit ENTER to continue
read i

msg forward port 8000 to port 8080 in the pod:
msg
msg kubectl port-forward PUT_POD_NAME_HERE 8000:8080
msg
msg send request to the pod:
msg
msg curl localhost:8000/
msg
msg stop the port forwarding
msg
msg hit ENTER to continue
read i

msg delete pod:
msg
msg kubectl delete -f pod-pvc1.yaml
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
