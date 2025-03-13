#!/bin/bash

set -e

STACK_NAME="livekit-meet-stack"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running"
    exit 1
fi

# Check if Docker Swarm is initialized
if ! docker node ls > /dev/null 2>&1; then
    echo "Docker Swarm not initialized. Initializing..."
    docker swarm init
fi

# Build the image first
echo "Building Docker image..."
docker build -t livekit-meet:latest .

# Deploy the stack
echo "Deploying Docker Stack: $STACK_NAME"
docker stack deploy --with-registry-auth --compose-file docker-stack.yml "$STACK_NAME"

echo "Docker Stack deployed successfully!"
echo "Access the application at http://localhost:3012"
echo
echo "To view stack services run: docker stack services $STACK_NAME"
echo "To remove stack run: docker stack rm $STACK_NAME"
