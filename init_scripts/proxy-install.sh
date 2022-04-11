#!/usr/bin/env bash

sudo apt-get -y update
sudo apt-get -y install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo mv /etc/nginx/sites-available/default .
sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default
#echo """upstream spartan_servers {
#        server ${SERVER1}:8080;
#        server ${SERVER2}:8080;
#        server ${SERVER3}:8080;
#}
#
#server {
#        listen 80;
#        server_name _;
#        location / {
#                proxy_set_header Host \$host;
#                proxy_set_header X-Real-IP \$remote_addr;
#                proxy_pass http://spartan_servers;
#        }
#}""" >> etc/nginx/sites-available/spartan_api
sudo tee -a /etc/nginx/sites-available/spartan_api > /dev/null <<EOT
upstream spartan_servers {
      server app.emile.devops106

}

server {
        listen 80;
        server_name _;
        location / {
                proxy_set_header Host \$host;
                proxy_set_header X-Real-IP \$remote_addr;
                proxy_pass http://spartan_servers;
        }
}
EOT
sudo ln -s /etc/nginx/sites-available/spartan_api /etc/nginx/sites-enabled/
sudo systemctl restart nginx

