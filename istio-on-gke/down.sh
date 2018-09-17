#!/bin/sh
export CLUSTER_NAME="test-istio"

gcloud -q container clusters delete $CLUSTER_NAME

gcloud -q compute firewall-rules delete allow-gateway-http 
gcloud -q compute firewall-rules delete allow-gateway-https
gcloud -q compute firewall-rules delete allow-gateway-promhttp2
