podman build -t observability-frontend:latest .

podman tag observability-frontend:latest observabilityacrwestusnodjs.azurecr.io/observability-frontend:latest
# ACR login
az acr login --name observabilityacrwestusnodjs.azurecr.io
# than
podman login observabilityacrwestusnodjs.azurecr.io
podman push --retry=5 --retry-delay=5s observabilityacrwestusnodjs.azurecr.io/observability-frontend:latest