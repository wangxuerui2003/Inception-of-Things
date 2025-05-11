k3d cluster create IoT-cluster \
  --port "0.0.0.0:80:80@loadbalancer" \
  --port "0.0.0.0:443:443@loadbalancer" \

# install argocd in the cluster
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# create dev namespace
kubectl create namespace dev

# wait for all argocd pods to be Running
kubectl -n argocd wait --for=condition=Ready pods --all --timeout=120s

kubectl -n argocd patch configmap argocd-cmd-params-cm \
  --type merge \
  -p '{"data":{"server.insecure":"true"}}'

kubectl -n argocd rollout restart deployment argocd-server

# wait for all argocd pods to be Running
kubectl -n argocd wait --for=condition=Ready pods --all --timeout=120s

kubectl apply -f ./conf/argocd-ingress.yaml

GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git clone git@github.com:wangxuerui2003/argocd-test-wxuerui.git
kubectl apply -f argocd-test-wxuerui/kustomization.yaml
rm -rf argocd-test-wxuerui

# get the argocd password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > argocd-password


