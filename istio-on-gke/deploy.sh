#!/bin/sh

# kubectl apply -f istio-0.8.0/install/kubernetes/istio-demo-auth.yaml
kubectl apply -f istio-0.8.0/install/kubernetes/istio-demo.yaml

kubectl label namespace default istio-injection=enabled

kubectl apply -f istio-0.8.0/samples/bookinfo/kube/bookinfo.yaml

istioctl create -f istio-0.8.0/samples/bookinfo/routing/bookinfo-gateway.yaml

export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')

gcloud compute firewall-rules create allow-gateway-http --allow tcp:$INGRESS_PORT
gcloud compute firewall-rules create allow-gateway-https --allow tcp:$SECURE_INGRESS_PORT

