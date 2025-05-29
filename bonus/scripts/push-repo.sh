#!/bin/bash

cd /vagrant/conf/wil
rm -rf .git
git init
git add .
git commit -m "init"
git remote add origin http://localhost:8081/root/wil.git
git push -u origin master