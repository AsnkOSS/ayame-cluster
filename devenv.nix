{ pkgs, ... }:

{
  packages = with pkgs; [
    git
    kubeseal
    kubectl
    kustomize
    kubernetes-helm
    kubeconform
    terraform
    argocd
    istioctl
    uv
    just
  ];

  languages.python.enable = true;
  languages.python.package = pkgs.python312;

  env = {
    KUBECONFIG = "./secrets/kubeconfig";
    TF_VAR_hcloud_token = "op://Ayame/Hcloud_Token/credential";
    AWS_ACCESS_KEY_ID = "op://Ayame/Hcloud_S3_Access_Key/credential";
    AWS_SECRET_ACCESS_KEY = "op://Ayame/Hcloud_S3_Secret_Key/credential";
  };

  enterShell = ''
    set -euo pipefail
    if [ ! -d ".venv" ]; then
      just uv-venv
    fi
    if [ ! -f "uv.lock" ]; then
      just uv-install
    fi
    source .venv/bin/activate
  '';

}
