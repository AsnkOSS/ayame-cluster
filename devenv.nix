{
  pkgs,
  ...
}:

{
  packages = with pkgs; [
    git
    kubeseal
    kubectl
    kustomize
    kubernetes-helm
    kubeconform
    terraform
    k0sctl
    argocd
    istioctl
    just
  ];

  env = {
    KUBECONFIG = "./secrets/kubeconfig";
    TF_VAR_hcloud_token = "op://Ayame/Hcloud_Token/credential";
    AWS_ACCESS_KEY_ID = "op://Ayame/Hcloud_S3_Access_Key/credential";
    AWS_SECRET_ACCESS_KEY = "op://Ayame/Hcloud_S3_Secret_Key/credential";
  };
}
