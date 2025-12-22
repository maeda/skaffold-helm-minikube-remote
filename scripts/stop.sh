#!/bin/bash

# Check if minikube is installed
if ! command -v minikube >/dev/null 2>&1; then
    echo "Error: minikube is not installed. Please install minikube first."
    exit 1
fi

# Stop minikube
echo "Stopping minikube..."
minikube stop

if [ $? -eq 0 ]; then
    echo "Minikube stopped successfully."
else
    echo "Failed to stop minikube."
    exit 1
fi