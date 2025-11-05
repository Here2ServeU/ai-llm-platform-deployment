
# AI / LLM Platform Deployment — Terraform + Multi‑Cloud Kubernetes (EKS, AKS, GKE, OKE)

> Started working on this project. I'm very excited about this opportunity!

Deploy a production‑lean GenAI stack on **managed Kubernetes** across **AWS EKS**, **Azure AKS**, **Google GKE**, or **Oracle OKE** (OCI) using **Terraform**. Then install **Argo CD**, **MLflow**, and **Grafana/Prometheus** via Helm.

> Beginner‑friendly: follow Step 1 → Step 4 for any cloud. You only need one cloud to get started.

## What you’ll deploy
- **Kubernetes cluster** (EKS/AKS/GKE/OKE) via Terraform
- **Argo CD** for GitOps
- **LLM Serving** Helm chart (OpenAI proxy / Hugging Face Inference endpoints placeholder)
- **MLflow** tracking (Bitnami chart values included)
- **Prometheus + Grafana** with an Inference dashboard

---

## Quick Start (choose one cloud)

### 0) Tools
Install: Terraform, kubectl, Helm, git, and the cloud CLI (aws/az/gcloud/oci).

### 1) Provision a cluster with Terraform
```bash
# AWS
cd infra/terraform/aws-eks && terraform init && terraform apply -auto-approve

# Azure
cd infra/terraform/azure-aks && terraform init && terraform apply -auto-approve

# GCP
cd infra/terraform/gcp-gke && terraform init && terraform apply -auto-approve

# OCI (OKE)
cd infra/terraform/oci-oke && terraform init && terraform apply -auto-approve
```

Each module prints export commands for kubeconfig. Run them (copy/paste) before proceeding.

### 2) Install platform components (Argo CD, MLflow, Grafana/Prometheus)
```bash
cd ../../..  # back to repo root
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Argo CD
helm upgrade --install argocd argo/argo-cd -n argocd --create-namespace   -f manifests/argo/values.yaml

# MLflow
helm upgrade --install mlflow bitnami/mlflow -n mlflow --create-namespace   -f manifests/mlflow/values.yaml

# Prometheus + Grafana
helm upgrade --install kube-prom prometheus-community/kube-prometheus-stack   -n monitoring --create-namespace -f manifests/monitoring/kps-values.yaml
```

### 3) Deploy LLM Serving (Helm)
```bash
helm upgrade --install llm-serving charts/llm-serving -n llm --create-namespace   -f values/llm-values.yaml
```

### 4) Access UIs
```bash
# Argo CD
kubectl -n argocd port-forward svc/argocd-server 8080:443
# Grafana (default admin/prom-operator)
kubectl -n monitoring port-forward svc/kube-prom-grafana 3000:80
# MLflow
kubectl -n mlflow port-forward svc/mlflow 5000:5000
```

## Repo layout
```
charts/llm-serving/                 # Helm chart for LLM proxy/serving
infra/terraform/{aws-eks,azure-aks,gcp-gke,oci-oke}  # Terraform IaC per cloud
manifests/{argo,mlflow,monitoring}  # Helm values for platform components
values/llm-values.yaml              # LLM serving chart values
dashboards/inference.json           # Grafana dashboard (skeleton)
```

## Notes
- Replace placeholders (region, project, tenancy OCIDs) in each Terraform module.
- This is a starter template; harden for production (IRSA/Workload Identity, Ingress/Certs, secrets).
