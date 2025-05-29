#!/bin/bash

echo "Waiting for argocd-server pod to be Ready..."
kubectl wait --namespace argocd \
  --for=condition=Ready pod \
  -l app.kubernetes.io/name=argocd-server \
  --timeout=180s
echo "Argocd-server pod is Ready."

# https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd
kubectl config set-context --current --namespace=argocd
argocd login --core

# https://argo-cd.readthedocs.io/en/stable/getting_started/#creating-apps-via-cli
kubectl create namespace gitlab
argocd app create wil --repo http://192.168.56.110:8081/root/wil.git --path . --dest-server https://kubernetes.default.svc --dest-namespace gitlab --sync-policy automated