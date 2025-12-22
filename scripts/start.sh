#!/bin/bash

# Function to check if a command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: $1 is not installed or not in PATH."
        exit 1
    fi
}

# Validate colima and minikube
check_command "colima"
check_command "minikube"

# Start Colima if not running
if ! colima status | grep -q "Running"; then
    echo "Starting Colima..."
    colima start
else
    echo "Colima is already running."
fi

# Start Minikube if not running
if ! minikube status | grep -q "host: Running"; then
    echo "Starting Minikube..."
    minikube start
else
    echo "Minikube is already running."
fi

echo "All systems are ready. You can start working on your project."

# Function to check if a command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: $1 is not installed or not in PATH."
        exit 1
    fi
}

# Validate only minikube
check_command "minikube"

# Start Minikube if not running
if ! minikube status | grep -q "host: Running"; then
    echo "Starting Minikube..."
    minikube start
else
    echo "Minikube is already running."
fi

echo "All systems are ready. You can start working on your project."
