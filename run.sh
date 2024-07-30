#!/bin/bash

image_name="open-webui"
container_name="open-webui"
host_port=3000
container_port=8080

# Collect environment variables from arguments
env_vars=""
for arg in "$@"
do
    env_vars="$env_vars -e $arg"
done

docker build -t "$image_name" .
docker stop "$container_name" &>/dev/null || true
docker rm "$container_name" &>/dev/null || true

docker run -d -p "$host_port":"$container_port" \
    --add-host=host.docker.internal:host-gateway \
    -v "${image_name}:/app/backend/data" \
    $env_vars \
    --name "$container_name" \
    --restart always \
    "$image_name"

docker image prune -f
