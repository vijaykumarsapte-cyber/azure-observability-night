podman build -t observability-backend:latest .

podman tag observability-backend:latest observabilityacrwestusnodjs.azurecr.io/observability-backend:latest
# ACR login
az acr login --name observabilityacrwestusnodjs.azurecr.io
# than
podman login observabilityacrwestusnodjs.azurecr.io
podman push --retry=5 --retry-delay=5s observabilityacrwestusnodjs.azurecr.io/observability-backend:latest