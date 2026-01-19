root_directory := justfile_directory()

tf-init:
    op run -- terraform init

tf-state:
    op run -- terraform state pull > terraform.tfstate

tf-plan:
    op run -- terraform plan

tf-apply:
    op run -- terraform apply

tf-destroy:
    op run -- terraform destroy

deploy:
    k0sctl apply -c {{ root_directory }}/deploy.yaml

reset:
    k0sctl reset -c {{ root_directory }}/deploy.yaml

kubeconfig:
    k0sctl kubeconfig -c {{ root_directory }}/deploy.yaml > secrets/kubeconfig
