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

ZONE=us-central1-a

msg forcing ZONE=$ZONE

[ -n "$ZONE" ] || die "missing env var ZONE"
[ -n "$CLUSTER" ] || die "missing env var CLUSTER"

cat <<__EOF__
ZONE=$ZONE
CLUSTER=$CLUSTER
__EOF__

msg run this command to delete the cluster:
msg gcloud container clusters delete $CLUSTER --zone $ZONE
