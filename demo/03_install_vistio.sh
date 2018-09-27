#!/bin/sh

export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

sed -e "s/{{LB_ADDRESS}}/$INGRESS_HOST/" 03-visual/vistio-svc.yaml.tmpl > 03-visual/vistio-svc.yaml
sed -e "s/{{LB_ADDRESS}}/$INGRESS_HOST/" 03-visual/vistio-with-ingress.yaml.tmpl > 03-visual/vistio-with-ingress.yaml

kubectl apply -f 03-visual/vistio-with-ingress.yaml
kubectl apply -f 03-visual/vistio-svc.yaml

echo "http://vistio-web.$INGRESS_HOST.nip.io"
