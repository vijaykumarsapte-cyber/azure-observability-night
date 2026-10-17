# Three-Tier Goal Tracker

The application has a Node.js frontend, a Go API, and PostgreSQL. The frontend is exposed through its `LoadBalancer` service. The API and database use `ClusterIP` services and are reachable inside the cluster. The frontend proxies `/api/*` requests to the private backend service.

## Azure DevOps pipeline

The repository-root `azure-pipelines.yml` is manual-only (`trigger: none` and `pr: none`). It validates the application, Terraform configuration, and Kubernetes YAML; builds and pushes the frontend and backend images tagged with the source commit; and rolls those images out to an existing AKS cluster. It never runs `terraform apply` or provisions Azure resources.

The database manifests and Dockerfile are retained and syntax-checked. The pipeline leaves the PostgreSQL workload alone: its checked-in Kubernetes Deployment has no persistent volume, and replacing its pod could lose database data. The application expects PostgreSQL at `postgres.database.svc.cluster.local:5432`; ensure that service is already running and its credentials/database match `k8s/backend/configmap.yaml` and `k8s/database/configmap.yaml`.

## Connect GitHub and create the pipeline

1. In Azure DevOps, create or select an organization and project. Open **Project settings → Repositories → GitHub connections** (or **Project settings → Service connections → New service connection → GitHub**) and authorize the Azure DevOps GitHub app using an account that can access this repository. Grant access only to the intended repository when prompted.
2. In **Pipelines → New pipeline**, choose **GitHub**, authorize/select the same repository, then choose **Existing Azure Pipelines YAML file** and select `/azure-pipelines.yml`. Save the pipeline. Do not enable a CI or PR trigger; the YAML explicitly disables both.
3. Create the Azure Resource Manager service connection in **Project settings → Service connections → New service connection → Azure Resource Manager**. Select workload identity federation where available, scope it to the subscription/resource group containing this existing cluster and registry, and name it. Grant this identity only the required permissions: ACR push (for example `AcrPush`), AKS cluster-user credential retrieval, and the AKS Kubernetes RBAC permissions to update resources in the `frontend` and `backend` namespaces. It also needs permission to read account/tenant metadata. Do not put a client secret or password in YAML.
4. Authorize the new service connection for this pipeline (or enable access only for explicitly selected pipelines). In **Pipelines → Environments**, create `existing-aks` and authorize this pipeline. Add environment checks/approvals if your release process requires them.
5. In `azure-pipelines.yml`, set `azureServiceConnection` to the exact service connection name. The other non-secret defaults match the checked-in `terraform.tfvars`: resource group `observability-rg-dev`, AKS `observability-aks`, ACR `observabilityacrwestusnodjs`, and Key Vault `keyvaultobservabilitydev`. If the deployed resources differ from the checked-in values, set the variables to the actual resource names.
6. Set `keyVaultIdentityClientId` as a pipeline variable to the existing AKS kubelet user-assigned identity client ID (the Terraform output `key_vault_csi_identity_client_id`). This identifier is not a credential. Protect any sensitive pipeline variables by marking them secret or, preferably, use a restricted variable group/Key Vault integration. The database password itself is never read by the pipeline.
7. In the existing Key Vault, ensure secret `DB-PASSWORD` exists and that the CSI identity has permission to read it. The AKS Key Vault Secrets Store CSI provider is enabled in the checked-in AKS Terraform module; verify it is enabled on the already-running cluster. The pipeline applies the backend SecretProviderClass after substituting the identity, Key Vault, and tenant IDs.
8. Confirm AKS kubelet identity has `AcrPull` on ACR (configured by the checked-in Terraform module), and that the Azure DevOps service connection can reach the AKS API. A private AKS API requires a self-hosted agent with network access; a Microsoft-hosted agent cannot reach a private endpoint.

## Run manually

In Azure DevOps, open **Pipelines**, select the pipeline, choose **Run pipeline**, select the intended GitHub branch, and start the run. Validation runs first; successful validation is required before images are built/pushed, then the existing AKS frontend/backend workloads are updated and checked for rollout completion. No Azure resource changes happen while creating or validating these files; Azure deployment actions occur only when you manually run the pipeline.

The frontend service is public (`LoadBalancer`); backend and PostgreSQL services are `ClusterIP`. Check the application after a successful run with:

```sh
kubectl get service frontend -n frontend
kubectl get pods -n backend
kubectl get pods -n database
```

The first `LoadBalancer` deployment may take a few minutes to receive an address. Use a separately reviewed infrastructure workflow if Terraform changes are needed. Never add an automatic Terraform apply to this application pipeline.

## Local validation commands

From the repository root:

```sh
cd 3-Tier-Application/Docker/frontend
npm install
npm test

cd ../backend
go test ./...

cd ../../../
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

Kubernetes deployment requires the Azure CLI, kubectl, and `envsubst` on the agent. Do not apply the CSI templates without substituting valid values.
