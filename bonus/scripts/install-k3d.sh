#!/bin/bash

# -- INSTALL K3D --
# https://k3d.io/stable/#installation
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# -- INSTALL KUBECTL --
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management

sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

# If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly

sudo apt-get update
sudo apt-get install -y kubectl

# -- CREATE K3D CLUSTER --
# https://k3d.io/stable/#quick-start
# https://k3d.io/v5.0.1/usage/exposing_services/
k3d cluster create mycluster -p "9080:80@loadbalancer" -p "9443:443@loadbalancer"

mkdir /home/vagrant/.kube
k3d kubeconfig write mycluster
cp /root/.config/k3d/kubeconfig-mycluster.yaml /home/vagrant/.kube/config
echo "export KUBECONFIG=/home/vagrant/.kube/config" >> /home/vagrant/.bash_profile
echo 'alias k=kubectl' >> /home/vagrant/.bash_profile
chown --recursive vagrant:vagrant /home/vagrant