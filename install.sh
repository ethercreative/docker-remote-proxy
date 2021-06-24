#!/bin/bash

# Variables
PROXY_PATH=/cnt/proxy
PWD=$(pwd)

# Create proxy directory
mkdir -p $PROXY_PATH

# Move into proxy directory
cd $PROXY_PATH || { echo "Failed to move into proxy directory"; exit 1; }

# Create .env file
touch .env
echo "DO_AUTH_TOKEN=" >> .env
echo "COMPOSE_PROJECT_NAME=proxy" >> .env

# Create acme.json
touch acme.json
chmod 600 acme.json

# Copy docker-compose
curl https://raw.githubusercontent.com/ethercreative/docker-remote-proxy/main/docker-compose.yml >> docker-compose.yml

# Copy Treafik config
curl https://raw.githubusercontent.com/ethercreative/docker-remote-proxy/main/traefik.yml >> traefik.yml

# Create the proxy network (if not exists)
docker network ls|grep proxy > /dev/null || docker network create --driver bridge proxy

# Start the proxy
docker-compose up -d

# Return to initial directory
cd "$PWD" || exit
