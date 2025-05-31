#!/bin/bash

# Create a k3d cluster with HTTP/HTTPS ports mapped to the load balancer
k3d cluster create mycluster -p "80:80@loadbalancer" -p "443:443@loadbalancer"

# https://argo-cd.readthedocs.io/en/stable/getting_started/
# Create the namespace and install Argo CD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# https://kubernetes.io/docs/reference/kubectl/generated/kubectl_wait/
# Wait for all pods in the argocd namespace to be ready
kubectl -n argocd wait --for=condition=Ready pods --all --timeout=180s

kubectl apply -f ./conf/agrocd-demo.yaml

# Expose the Argo CD API server via LoadBalancer service
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Retrieve the initial Argo CD admin password
echo "Initial Argo CD admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo  

# Forward port 8080 on localhost to port 443 on the Argo CD server
echo "Starting port-forward to Argo CD (Ctrl+C to stop)..."
kubectl port-forward svc/argocd-server -n argocd 8080:443