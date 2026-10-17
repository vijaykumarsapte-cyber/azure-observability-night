podman build -t postgres:15 .

podman tag postgres:15 observabilityacrwestusnodjs.azurecr.io/postgres:15
# ACR login
az acr login --name observabilityacrwestusnodjs.azurecr.io
# than
podman login observabilityacrwestusnodjs.azurecr.io
podman push --retry=5 --retry-delay=5s observabilityacrwestusnodjs.azurecr.io/postgres:15