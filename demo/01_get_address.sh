#!/bin/sh

export LB_ADDRESS=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "http://${LB_ADDRESS}/productpage"
