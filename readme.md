# Local Development Setup (Quick Guide)

This document describes the **minimal steps** to run the project locally using **Minikube + Skaffold + Helm**.

It assumes macOS, but the flow is the same for Linux-based dev VMs.

---

## 1. Install prerequisites

```bash
brew install docker colima minikube skaffold helm
```

---

## 2. Start Docker runtime (macOS)

Docker CLI does not include a daemon on macOS.
Colima provides a Linux VM with Docker Engine.

```bash
colima start --cpu 12 --memory 17
docker context use colima
docker ps
```

> ⚠️ Memory matters.
> If Minikube or Airflow pods fail to schedule, increase Colima memory.

---

## 3. Start Minikube

Use Docker as the driver so Minikube reuses the Colima runtime.

```bash
minikube start --driver=docker --cpus=12 --memory=16384
kubectl get nodes
```

---

## 4. Run the stack with Skaffold

```bash
skaffold dev
```

---

## 5. Access the application (Airflow)

```bash
kubectl port-forward svc/airflow-webserver 8080:8080 -n airflow
```

Open:

```
http://localhost:8080
```

---

## 6. Common sanity checks

```bash
kubectl get pods -n airflow
kubectl get pvc -n airflow
kubectl get events -n airflow --sort-by=.metadata.creationTimestamp
```

---

## 7. When things get weird (recommended reset)

Local clusters are **disposable**.
If PVCs, pods, or deployments get stuck:

```bash
minikube delete
minikube start --driver=docker --cpus=12 --memory=16384
skaffold dev --cleanup=false
```

This is often faster and safer than debugging residual state.

---

## Notes

* Configuration lives in `values-dev.yaml`
* `skaffold.yaml` is intentionally minimal (image build + deploy only)
* Local setup uses **LocalExecutor** and **no Redis**
* KubernetesPodOperator works normally in this mode
