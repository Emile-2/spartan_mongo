#!/usr/bin/env bash

#
#sudo apt-get remove docker -y docker-engine docker.io containerd runc
#sudo apt-get update
#sudo apt-get install -y ca-certificates curl gnupg lsb-release
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#sudo apt-get update
#sudo apt-get install -y docker-ce docker-ce-cli containerd.io
#sudo usermod -a -G docker ubuntu
#
#sudo docker run -d hello-world
#sudo docker pull edspt/spartan_mongo:latest
sudo docker run -d -v /home/ubuntu/log:/log -p 8080:8080 edspt/spartan_mongo:latest