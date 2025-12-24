#!/bin/bash

set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew if not present (macOS)
install_homebrew() {
    if ! command_exists brew; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

# Install Docker CLI
install_docker() {
    if ! command_exists docker; then
        echo "Docker CLI not found. Installing Docker..."
        brew install docker@29.1.3
    else
        echo "Docker CLI is already installed."
    fi
}

# Install Colima
install_colima() {
    if ! command_exists colima; then
        echo "Colima not found. Installing Colima..."
        brew install colima@0.9.1
    else
        echo "Colima is already installed."
    fi
}

# Install Minikube
install_minikube() {
    if ! command_exists minikube; then
        echo "Minikube not found. Installing Minikube..."
        brew install minikube@1.37.0
    else
        echo "Minikube is already installed."
    fi
}

# Install Helm
install_helm() {
    if ! command_exists helm; then
        echo "Helm not found. Installing Helm..."
        brew install helm@4.0.4

        helm repo add apache-airflow https://airflow.apache.org # add airflow helm repo

        # 1. Add the Helm repo
        helm repo add csi-secrets-store-provider-azure https://azure.github.io/secrets-store-csi-driver-provider-azure/charts
        helm repo update

        # 2. Install the Driver and the Azure Provider
        helm install csi csi-secrets-store-provider-azure/csi-secrets-store-provider-azure \
            --namespace kube-system \
            --set secrets-store-csi-driver.syncSecret.enabled=true
    else
        echo "Helm is already installed."
    fi
}

# Install Skaffold
install_skaffold() {
    if ! command_exists skaffold; then
        echo "Skaffold not found. Installing Skaffold..."
        brew install skaffold@2.17.0
    else
        echo "Skaffold is already installed."
    fi
}

# Main script
echo "Checking and installing required tools..."

install_homebrew
install_docker
install_colima
install_minikube
install_helm
install_skaffold

echo "All required tools are installed."