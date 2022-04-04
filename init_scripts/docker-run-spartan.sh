docker run -d hello-world
docker pull edspt/spartan_mongo:latest
cat /home/ubuntu/database.config
docker run -d -v /home/ubuntu/database.config:/database.config -v /home/ubuntu/log:/log -p 8080:8080 edspt/spartan_mongo:latest