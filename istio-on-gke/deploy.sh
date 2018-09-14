#!/bin/sh

ISTIO_VERSION=1.0.2

if [ ! -d istio-$ISTIO_VERSION ];
then
  if [ ! -f istio-$ISTIO_VERSION-linux.tar.gz ]; 
  then
    curl -LO https://github.com/istio/istio/releases/download/$ISTIO_VERSION/istio-$ISTIO_VERSION-linux.tar.gz
  fi
  tar xzf istio-$ISTIO_VERSION-linux.tar.gz
fi

# kubectl apply -f istio-$ISTIO_VERSION/install/kubernetes/istio-demo-auth.yaml
kubectl apply -f istio-$ISTIO_VERSION/install/kubernetes/istio-demo.yaml

kubectl label namespace default istio-injection=enabled

# Deploy sample app

kubectl apply -f istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/bookinfo.yaml

istio-$ISTIO_VERSION/bin/istioctl create -f istio-$ISTIO_VERSION/samples/bookinfo/networking/bookinfo-gateway.yaml

export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')

gcloud compute firewall-rules create allow-gateway-http --allow tcp:$INGRESS_PORT
gcloud compute firewall-rules create allow-gateway-https --allow tcp:$SECURE_INGRESS_PORT

