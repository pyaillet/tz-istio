####
#### Part 1 : Deploy
####

# Deploy BookInfo app
kubectl apply -f 01-deploy/bookinfo.yaml
./istioctl create -f 01-deploy/bookinfo-gateway.yaml

# List pods / services
kubectl get pods
kubectl get services

# Go to index page
export LB_ADDRESS=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "http://${LB_ADDRESS}/productpage"

# Activate istio injection
kubectl label namespace default istio-injection=enabled

# Delete productpage pod
kubectl delete pods <productpage pod>

# Re-create all pods
kubectl delete -f 01-deploy/bookinfo.yaml && kubectl create -f 01-deploy/bookinfo.yaml

# Show that istio was injected
kubectl get pods
kubectl describe pods <productpage pod>

####
#### Part 2 : Patterns
####

# Show quick response time
./hey -n 50 -c 50 http://${LB_ADDRESS}/api/v1/products/1

# Add delay
./istioctl create -f 02-patterns/delay.yaml
./hey -n 50 -c 50 http://${LB_ADDRESS}/api/v1/products/1

# Add timeout
./istioctl replace -f 02-patterns/timeout.yaml
./hey -n 50 -c 50 http://${LB_ADDRESS}/api/v1/products/1

# Add fault
./istioctl replace -f 02-patterns/fault.yaml
./hey -n 50 -c 50 http://${LB_ADDRESS}/api/v1/products/1

# Add retry
./istioctl replace -f 02-patterns/retry.yaml
./hey -n 50 -c 50 http://${LB_ADDRESS}/api/v1/products/1

# Cleanup
./istioctl delete virtualservice details

####
#### Part 3 : Observation
####
sed -e "s/{{LB_ADDRESS}}/$INGRESS_HOST/" vistio/vistio-svc.yaml.tmpl > vistio/vistio-svc.yaml

kubectl apply -f vistio/vistio-with-ingress.yaml
kubectl apply -f vistio/vistio-svc.yaml

open http://vistio-web.$INGRESS_HOST.nip.io
./hey -n 500 -c 50 http://${LB_ADDRESS}/api/v1/products/1

# Ajouter des faults pour constater la visu
./istioctl replace -f 02-patterns/fault.yaml
./hey -n 500 -c 50 http://${LB_ADDRESS}/api/v1/products/1

./istioctl delete -f 02-patterns/fault.yaml

####
#### Part 4 : Routing
####

# Show review pods labels
kubectl describe pods <review pods>

# Add destination rule
./istioctl create -f 04-routing/destination.yaml

# Route traffic to v2
./istioctl create -f 04-routing/v2.yaml

# Route traffic to v2-v3
./istioctl replace -f 04-routing/v2-v3.yaml

# Route traffic to v3
./istioctl replace -f 04-routing/v3.yaml

####
#### Part 5 : Others
####

