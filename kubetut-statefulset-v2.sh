#!/bin/bash
#
# https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/

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
msg watch pods:
msg
msg kubectl get pods -w -l app=web-scratch
msg
msg create statefulset:
msg
msg kubectl create -f statefulset-v2.yaml
msg
msg kubectl get statefulset,pv,pvc,pod,service
msg
msg hit ENTER to continue
read i

msg examine pod ordinal index:
msg
msg kubectl get pods -l app=web-scratch
msg
msg examine pod network identity:
msg
msg kubectl exec web-0 -- /go/bin/app -version
msg kubectl exec web-1 -- /go/bin/app -version
msg
msg hit ENTER to continue
read i

msg execute a container that provides the nslookup command:
msg
msg kubectl run -i --tty --image busybox:1.28 dns-test --restart=Never --rm
msg
msg then query the pods hostnames in the in-cluster DNS:
msg
msg '# nslookup podName-index.serviceName:'
msg nslookup web-0.web-scratch
msg nslookup web-1.web-scratch
msg
msg hit ENTER to continue
read i

msg delete all pods in the statefulset:
msg
msg kubectl delete pod -l app=web-scratch
msg
msg check the pods will be recreated:
msg
msg kubectl get pod -w -l app=web-scratch
msg
msg pods ordinals, hostnames, SRV records, and A record names not have not changed
msg but the IP addresses associated with the Pods may have changed.
msg check it by re-querying the DNS:
msg
msg kubectl run -i --tty --image busybox:1.28 dns-test --restart=Never --rm
msg nslookup web-0.web-scratch
msg nslookup web-1.web-scratch
msg
msg hit ENTER to continue
read i

msg write pods hostnames to their stable storage:
msg
msg kubectl exec web-0 -- /go/bin/app -touch=/disk-stateful/version.txt -version
msg kubectl exec web-1 -- /go/bin/app -touch=/disk-stateful/version.txt -version
msg
msg verify storage contents:
msg
msg kubectl port-forward web-0 8000:8080
msg curl localhost:8000/www/disk-stateful/version.txt
msg
msg kubectl port-forward web-1 8000:8080
msg curl localhost:8000/www/disk-stateful/version.txt
msg
msg now stop the port forwarding
msg
msg hit ENTER to continue
read i

msg delete all pods in the statefulset:
msg
msg kubectl delete pod -l app=web-scratch
msg
msg wait for all of the pods to transition to Running and Ready:
msg
msg kubectl get pod -w -l app=web-scratch
msg
msg again verify storage contents:
msg
msg kubectl port-forward web-0 8000:8080
msg curl localhost:8000/www/disk-stateful/version.txt
msg
msg kubectl port-forward web-1 8000:8080
msg curl localhost:8000/www/disk-stateful/version.txt
msg
msg now stop the port forwarding
msg
msg hit ENTER to continue
read i

msg scale up the number of replicas to 5:
msg
msg kubectl get pod -w -l app=web-scratch
msg
msg kubectl scale sts web --replicas=5
msg
msg scale down the number of replicas to 3:
msg
msg kubectl get pod -w -l app=web-scratch
msg
msg kubectl patch sts web -p '{"spec":{"replicas":3}}'
msg
msg examine pvcs:
msg
msg kubectl get pvc -l app=web-scratch
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

