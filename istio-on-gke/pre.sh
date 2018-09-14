#!/bin/sh
export CLUSTER_NAME="test-istio"

gcloud container clusters \
	create --preemptible \
	--zone $ZONE \
	--num-nodes 5 \
	$CLUSTER_NAME

gcloud container clusters \
	get-credentials $CLUSTER_NAME \
	--zone $ZONE \
    	--project $GOOGLE_CLOUD_PROJECT

kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole=cluster-admin \
    --user=$(gcloud config get-value core/account)

