# 🚀 Airflow Remote Platform Configuration

This repository provides a centralized, "No-Build" Skaffold and Helm configuration for local Airflow development. It is designed to allow developers to run a full Airflow 3 stack on Minikube without needing to build Docker images locally, using `minikube mount` to sync DAGs instead.

## 📦 What's Inside?

* **`skaffold-remote-dev.yaml`**: The shared Skaffold configuration.
* **`helm/airflow`**: A pre-configured Helm chart optimized for local development.
* **Multi-Component Mounts**: Pre-configured support for Airflow 3 components (`apiServer`, `dagProcessor`, `scheduler`, and `triggerer`) to read local DAGs.

---

## 🛠 How to Use in Your Project

Follow these steps to use this centralized configuration in your local DAG repository.

### 1. Create a `skaffold.yaml`

In the root of your local DAG project, create a `skaffold.yaml` that references this remote repository.

```yaml
apiVersion: skaffold/v4beta7
kind: Config
metadata:
  name: local-dag-dev

# Import the centralized platform configuration
requires:
  - configs: ["airflow-local"]
    git:
      repo: https://github.com/maeda/skaffold-helm-minikube-remote.git
      path: skaffold-remote-dev.yaml
      ref: main

# OPTIONAL!
deploy:
  helm:
    releases:
      - name: airflow
        # Overlay your local environment settings
        valuesFiles:
          - values-local.yaml

```

### 2. Create a `values-local.yaml` (Optional step)

This file configures the "No-Build" bridge between your local laptop and the Airflow cluster and this is set as a default on remote repository.

```yaml
# values-local.yaml
airflow:
  # The bridge: Connects the Minikube /app mount to Airflow components
  _dags_mount: &dags_mount
    extraVolumes:
      - name: local-dags
        hostPath:
          path: /app/dags   # Path inside Minikube VM
          type: Directory
    extraVolumeMounts:
      - name: local-dags
        mountPath: /opt/airflow/dags
        readOnly: true

  # Apply the mount to all Airflow 3 components
  apiServer:
    <<: *dags_mount
  dagProcessor:
    <<: *dags_mount
  scheduler:
    <<: *dags_mount
  triggerer:
    <<: *dags_mount

  # Database Initialization
  migrateDatabaseJob:
    useHelmHooks: false
  createUserJob:
    useHelmHooks: false

```

### 3. Start the Development Loop

Run these commands in order to start your local environment:

```bash
# 1. Start the file bridge (Must stay running)
# Map your current project folder to /app inside Minikube

minikube mount .:/app

# 2. In a new terminal, start Skaffold
skaffold dev

```

---

## 💡 Key Concepts

### The "No-Build" Workflow

Instead of spending time building and pushing Docker images, this setup pulls a standard Airflow image from the registry. Your local code is injected directly into the running pods via `hostPath` volumes.

* **Edit code locally** ➔ **Save** ➔ **Refresh Airflow UI**.
* Changes are visible in ~30-60 seconds (Airflow's parsing interval).

### Airflow 3 Architecture

This configuration is specifically optimized for Airflow 3. Unlike older versions, Airflow 3 separates the API and DAG processing. This remote config ensures that the `apiServer` (UI/API) and the `dagProcessor` (Parsing) both see your local files simultaneously.

## 📋 Prerequisites

* **Minikube** (Driver: Docker or Colima).
* **Skaffold** v2.17.0+.
* **Helm** v4.0.4+.
* **Git** access to this repository.