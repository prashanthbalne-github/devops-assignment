As part of the Assignment, I have did the following steps to complete Part-1,2,3.

Prerquesites
===============
* Launched a t2-micro Ubuntu Linux machine on AWS
* Eanabled SSH access to the same machine by generating a new key-pair .pem file
* Insalled docker and docker-compose on that machine using packege manager "apt-get" with the folllwoing commands
        sudo apt-get update                     #To update the package to the latest
        sudo apt-get install docker.io          #To install the docker with latest verison available
        sudo apt-get install docker-compose     #To install the docker-compose
        sudo su                                 #To switch to the root user
        docker --version
        docker-compose --version
        git --version                           #TO check the running versions on the softwares

Part-1
===============
Cloned the git repo onto the Machine using command
        git clone <repo URL>
        cd /csvserver/solution
Pulled the docker images as given in the instructions using commands
        docker pull infracloudio/csvserver:latest
        docker pull prom/prometheus:v2.22.0
        docker images                           #TO check the list of images
Output:

root@ip-172-31-3-112:/home/ubuntu/csvserver/solution# docker images
REPOSITORY               TAG       IMAGE ID       CREATED             SIZE
csvserver-new            v1.3      1482b906eeb0   About an hour ago   237MB
csvserver-new            v1.1      61b8b6caac73   2 hours ago         237MB
infracloudio/csvserver   latest    8cb989ef80b5   2 years ago         237MB
prom/prometheus          v2.22.0   7adf5a25557b   3 years ago         168MB

Written a bash script gencsv.sh to generate a file named inputFile:

#!/bin/bash

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <start_index> <end_index>"
    exit 1
fi

# Extract start and end indices from command line arguments
start_index=$1
end_index=$2

# Validate that start_index is less than or equal to end_index
if [ "$start_index" -gt "$end_index" ]; then
    echo "Error: start_index must be less than or equal to end_index"
    exit 1
fi

# Generate CSV content and save it to a file named inputFile
for ((i = start_index; i <= end_index; i++)); do
    echo "$i, $((RANDOM % 100))" >> inputFile
done

echo "CSV file generated successfully: inputFile"

* Given executable permissions to the above file using
        chmod +x gencsv.sh
* TO run the container using above image
        docker run -d --name csvserver --mount type=bind,source="$(pwd)"/inputFile,target=/csvserver/inputdata infracloudio/csvserver:latest
* to check the container info used the following command
        docker inspect <container ID>
* To enable the given port and pass the env variable for Orange border used the following commands
        doocker stop <container ID>
        docker rm <conatiner ID>
        docker run -d --name csvserver -e CSVSERVER_BORDER=Orange -p 9393:9300 --mount type=bind,source="$(pwd)"/inputFile,target=/csvserver/inputdata infracloudio/csvserver:latest
* Checked with the container access by enabling the given port by adding it to the inbound rules at AWS machine level and

http://localhost:9393
Output:

Welcome to the CSV Server
Index   Value
2       86
3       68
4       80
5       40
6       74
7       7
8       39

* Added Outputs to the files
part-1-cmd, part-1-output
Part-2, 3
=====================
Written a docker-compose.yaml and its required files and made them up and running using following commands

version: '3'
services:
  csvserver:
    image: csvserver-new:v1.3
    env_file:
      - csvserver.env
    ports:
      - "9393:9393"
    volumes:
      - ./inputFile:/csvserver/inputdata
    networks:
      - default_network
  prometheus:
    image: prom/prometheus:v2.22.0
    volumes:
      - ./prometheus.yaml:/etc/prometheus/prometheus.yaml:ro
    ports:
      - "9090:9090"
    depends_on:
      - csvserver
    networks:
      - default_network

networks:
  default_network:
    driver: bridge

    
         docker-compose up -d
Output:

root@ip-172-31-3-112:/home/ubuntu/csvserver/solution# docker ps -a
CONTAINER ID   IMAGE                     COMMAND                  CREATED             STATUS             PORTS                                       NAMES
59f7838a90b2   csvserver-new:v1.3        "/bin/bash"              About an hour ago   Up About an hour   9300/tcp                                    nervous_chebyshev
b7a0027c592a   prom/prometheus:v2.22.0   "/bin/prometheus --c…"   2 hours ago         Up 2 hours         0.0.0.0:9090->9090/tcp, :::9090->9090/tcp   solution_prometheus_1

* Tried accessing the prometheus from http://localhost:9090, it worked

    

