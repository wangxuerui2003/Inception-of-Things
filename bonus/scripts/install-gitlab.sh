#!/bin/bash

# https://about.gitlab.com/install/#ubuntu
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash

# https://docs.gitlab.com/omnibus/installation/#set-up-the-initial-account
sudo EXTERNAL_URL="http://gitlab.example.com" apt install gitlab-ee

# https://docs.gitlab.com/omnibus/settings/nginx/#set-the-nginx-listen-port
sudo sed -i "s/^[#[:space:]]*nginx\['listen_port'\] *= *.*/nginx['listen_port'] = 8081/" /etc/gitlab/gitlab.rb
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart # Sometimes get TERM
exit 0
