#!/usr/bin/env bash
set -euo pipefail

# Authenticate with the Azure CLI. Select the intended subscription interactively
# or pass its ID locally; do not commit subscription-specific credentials.
az login
az account set --subscription "<subscription-id>"

# Build the application images from the repository root.
docker build -t observability-frontend:local 3-Tier-Application/Docker/frontend
docker build -t observability-backend:local 3-Tier-Application/Docker/backend

# Authenticate to the existing registry with your Azure identity, then push.
ACR_NAME="observabilityacrwestusnodjs"
IMAGE_TAG="local"
az acr login --name "$ACR_NAME"
docker tag observability-frontend:local "$ACR_NAME.azurecr.io/observability-frontend:$IMAGE_TAG"
docker tag observability-backend:local "$ACR_NAME.azurecr.io/observability-backend:$IMAGE_TAG"
docker push "$ACR_NAME.azurecr.io/observability-frontend:$IMAGE_TAG"
docker push "$ACR_NAME.azurecr.io/observability-backend:$IMAGE_TAG"

# Connect kubectl to the existing cluster and inspect workloads.
az aks get-credentials --resource-group observability-rg-dev --name observability-aks --overwrite-existing
kubectl get nodes
kubectl get pods --all-namespaces

# Store database credentials in Key Vault through your approved secret-management
# workflow. Never put a database password or ACR admin password in this file.
