#!/bin/bash

# -- INSTALL K3S SERVER --
# https://docs.k3s.io/installation/requirements?os=debian
# https://docs.k3s.io/installation/configuration

sudo ufw disable
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--token 12345 -i 192.168.56.110" sh -s -

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

# -- CONFIGURE KUBECONFIG --
# https://devops.stackexchange.com/questions/16043/error-error-loading-config-file-etc-rancher-k3s-k3s-yaml-open-etc-rancher

export KUBECONFIG=/home/vagrant/.kube/config
mkdir /home/vagrant/.kube
sudo k3s kubectl config view --raw > "$KUBECONFIG"
echo 'export KUBECONFIG=~/.kube/config' >> /home/vagrant/.bash_profile
echo 'alias k=kubectl' >> /home/vagrant/.bash_profile
chown --recursive vagrant:vagrant /home/vagrant
