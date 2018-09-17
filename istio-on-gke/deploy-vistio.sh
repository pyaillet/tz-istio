#!/bin/sh

export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

sed -e "s/{{LB_ADDRESS}}/$INGRESS_HOST/" vistio/vistio-svc.yaml.tmpl > vistio/vistio-svc.yaml

kubectl apply -f vistio/vistio-with-ingress.yaml
kubectl apply -f vistio/vistio-svc.yaml