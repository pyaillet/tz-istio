#!/bin/sh
export CLUSTER_NAME="test-istio"

gcloud container clusters delete $CLUSTER_NAME

