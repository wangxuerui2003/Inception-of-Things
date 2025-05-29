#!/bin/bash

# https://argo-cd.readthedocs.io/en/stable/getting_started/

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# https://argo-cd.readthedocs.io/en/stable/cli_installation/

curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#traefik-v30
# https://argo-cd.readthedocs.io/en/stable/operator-manual/argocd-cmd-params-cm-yaml/

# Wait for traefik to be ready
# Add ingressroute to argocd-server
# Update configmap argocd-cmd-params-cm to change the API server to run with TLS disabled
# Restart argocd-server deployment to apply the changes
echo "Waiting for Traefik pod to be created..."
until kubectl get pods -n kube-system -l app.kubernetes.io/name=traefik | grep -q 'traefik'; do
  sleep 30
done
echo "Traefik pod created."

echo "Waiting for Traefik pod to be Ready..."
kubectl wait --namespace kube-system \
  --for=condition=Ready pod \
  -l app.kubernetes.io/name=traefik \
  --timeout=180s

kubectl apply -n argocd -f /vagrant/conf/argocd
kubectl rollout restart deployment argocd-server -n argocd

