{
  pkgs,
  ...
}:

{
  packages = [
    pkgs.git
    pkgs.terraform
    pkgs.kubectl
    pkgs.k3sup
  ];
  dotenv = {
    enable = true;
    filename = [
      ".env"
    ];
  };
}
