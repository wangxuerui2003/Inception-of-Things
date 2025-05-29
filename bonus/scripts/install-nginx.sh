#!/bin/bash

sudo apt-get update
sudo apt-get install -y nginx
sudo cp /vagrant/conf/nginx/default /etc/nginx/sites-available/default
sudo systemctl enable nginx
sudo systemctl restart nginx