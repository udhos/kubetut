#!/bin/bash
#
# https://github.com/udhos/kubetut

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

ZONE=us-central1-a
IMAGE_BASE=docker.io/udhos/web-scratch
IMAGE=$IMAGE_BASE:latest

msg forcing ZONE=$ZONE
msg forcing IMAGE=$IMAGE

[ -n "$PROJECT" ] || die "missing env var PROJECT"
[ -n "$ZONE" ] || die "missing env var ZONE"
[ -n "$CLUSTER" ] || die "missing env var CLUSTER"
[ -n "$IMAGE" ] || die "missing env var IMAGE"

cat <<__EOF__
PROJECT=$PROJECT
ZONE=$ZONE
CLUSTER=$CLUSTER
IMAGE=$IMAGE
__EOF__

run gcloud config set project $PROJECT 

run gcloud container clusters create $CLUSTER \
	--zone=$ZONE \
	--cluster-version=latest \
	--machine-type=n1-standard-1 \
	--enable-autoscaling --min-nodes=1 --max-nodes=3 \
	--num-nodes=2 \
	--enable-autorepair \
	--scopes=service-control,service-management,compute-rw,storage-ro,cloud-platform,logging-write,monitoring-write,pubsub,datastore

msg you can verify the cluster with:
msg
msg gcloud container clusters describe $CLUSTER --zone=$ZONE
msg
msg hit ENTER to continue
read i

msg verify cluster version:
msg
msg kubectl version
msg
msg hit ENTER to continue
read i

msg verify cluster details:
msg
msg kubectl cluster-info
msg
msg hit ENTER to continue
read i

msg list nodes:
msg
msg kubectl get nodes
msg
msg hit ENTER to continue
read i

deployment=hello-web

cmd="kubectl run $deployment --image=$IMAGE --requests=cpu=50m --port 8080"
#cmd="kubectl create deployment $deployment --image=$IMAGE"
msg creating deployment:
msg
msg $cmd
msg
run $cmd

msg list deployments:
msg
msg kubectl get deployments
msg
msg hit ENTER to continue
read i

msg get pod name:
msg
msg kubectl get pod
msg
msg get logs from pod:
msg
msg kubectl logs PUT_PODE_NAME_HERE
msg
msg hit ENTER to continue
read i

msg the app is up but is not exposed yet.
msg
msg run a proxy to access the cluster:
msg
msg "kubectl proxy ;# localhost only"
msg "kubectl proxy --address=0.0.0.0 --accept-hosts='.*' ;# fully open"
msg
msg query the version:
msg
msg curl http://localhost:8001/version
msg
msg hit ENTER to continue
read i

msg get pod name:
msg
msg "POD_NAME=\$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{\"\\n\"}}{{end}}')"
msg
msg send a request to the pod:
msg
msg 'curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/'
msg
msg now you can stop the kubectl proxy
msg
msg hit ENTER to continue
read i

msg run command in pods container:
msg
msg 'kubectl exec $POD_NAME -- env            ;# normal container'
msg 'kubectl exec $POD_NAME -- /go/bin/app -h ;# scratch container'
msg
msg run interactive session in pods container:
msg
msg 'kubectl exec -ti $POD_NAME -- bash           ;# normal container'
msg 'kubectl exec -ti $POD_NAME -- /go/bin/app -h ;# scratch container'
msg
msg hit ENTER to continue
read i

service=service-$deployment

msg create a service to expose the deployment:
msg
msg kubectl get svc
msg
msg kubectl expose deployment $deployment --type LoadBalancer --port 80 --target-port 8080 --name $service
msg
msg kubectl get svc
msg
msg curl external_ip:port
msg
msg hit ENTER to continue
read i

hpa=hpa-$deployment

msg create autoscaler:
msg
msg kubectl autoscale deployment $deployment --cpu-percent=50 --min=2 --max=10 --name=$hpa
msg
msg check:
msg
msg kubectl get pods
msg kubectl get hpa
msg
msg send some load:
msg
msg 'while :; do curl external_ip:port; done'
msg
msg ab -l -c 200 -n 100000 external_ip:port/
msg
msg check load:
msg
msg kubectl get hpa --watch
msg
msg delete autoscaler:
msg
msg kubectl delete hpa $hpa
msg
msg hit ENTER to continue
read i

msg change the deployment:
msg
msg kubectl set image deployments/$deployment $deployment=$IMAGE:v4 --record=true
msg
msg you can modify the change cause:
msg kubectl annotate deployments/$deployment kubernetes.io/change-cause="crazy tag"
msg
msg check error:
msg
msg kubectl get pod
msg 'NAME                         READY   STATUS             RESTARTS   AGE'
msg 'hello-web-5fdd857868-4tbb5   0/1     ImagePullBackOff   0          3m42s'
msg 'hello-web-779454fd45-4cmc8   1/1     Running            0          3m42s'
msg 'hello-web-779454fd45-d9dzf   1/1     Running            0          3m42s'
msg
msg find error:
msg
msg kubectl describe pod hello-web-5fdd857868-4tbb5
msg
msg fix error:
msg
msg kubectl set image deployments/$deployment $deployment=$IMAGE:0.4 --record=true
msg
msg kubectl get pod
msg
msg check rollout status:
msg
msg kubectl rollout status deployments/$deployment
msg
msg hit ENTER to continue
read i

msg you can undo a rollout
msg
msg check revisions:
msg
msg kubectl rollout history deployments
msg
msg look at specific revision:
msg
msg kubectl rollout history deployments/$deployment --revision=2
msg
msg 'rollback to specific revision 3 (default is 0 -- last revision):'
msg
msg kubectl rollout undo deployments/$deployment --to-revision=3
msg
msg hit ENTER to continue
read i


msg delete service:
msg
msg kubectl delete service $service
msg
msg hit ENTER to continue
read i

msg assign label to pod:
msg
msg kubectl label pod POD_NAME app=v1
msg
msg list pods by label:
msg
msg kubectl get pods -l app=v1
msg
msg verity the pod has the label:
msg
msg kubectl describe pods POD_NAME
msg
msg hit ENTER to continue
read i

cmd="kubectl delete deployment $deployment"
msg deleting deployment:
msg
msg $cmd
msg
run $cmd

