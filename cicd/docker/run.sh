#!/bin/sh
# Export the active docker machine IP
export DOCKER_HOST_IP=$(docker-machine ip $(docker-machine active))

# Remove existing containers
docker-compose stop
docker-compose rm -f

#start containers
docker-compose up -d

#attach to logs
docker-compose logs -f
