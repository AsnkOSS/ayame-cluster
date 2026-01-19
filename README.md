# Structure

### devenv.nix env

- KUBECONFIG=[kubeconfig path]
- TF_VAR_hcloud_token=[hcloud auth token]
- AWS_ACCESS_KEY_ID=[hcloud object storage key id]
- AWS_SECRET_ACCESS_KEY=[hcloud object storage access key]

### secrets folder

- ayame-cluster.pub
- ayame-cluster.key
- kubeconfig

## deployment

- requires nix direnv devenv in environment
- setup devenv envs, using 1password to store secrets
- add cluster primary ssh key and pub to secrets folder
- change terraform/main.tf and terraform/variabes.tf to customize your cluster
- run command down blow
- talos does not have a ssh control service, designed only for k8s

```bash
just tf-init
just tf-plan
just tf-apply
just deploy
```

- get **kubeconfig** from secrets/kubeconfig
- only for destroying cluster, remember to lock volumes

```bash
just tf-destroy
```

- init base projects
- change platform/base/argocd/projects configs to your repo

```bash
kubectl apply -k platform/base
```

- add apps into platform/apps, infra components to platform/infra
- wait for argocd to run then change the cluster name to your custom name in web
- wait for argocd to detect and start or run your apps/infras
- every apps/infras will using git to sync, press sync and refresh in argo web
