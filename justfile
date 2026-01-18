root_directory := justfile_directory()

tf-init:
    op run -- terraform init

tf-plan:
    op run -- terraform plan

tf-apply:
    op run -- terraform apply

tf-destroy:
    op run -- terraform destroy

kk-create:
    {{ root_directory }}/kubekey/kk create cluster -i {{ root_directory }}/kubekey/inventory.yaml -c {{ root_directory }}/kubekey/config.yaml --with-kubernetes v1.34.3

kk-add:
    {{ root_directory }}/kubekey/kk add nodes -i {{ root_directory }}/kubekey/inventory.yaml -c {{ root_directory }}/kubekey/config.yaml
