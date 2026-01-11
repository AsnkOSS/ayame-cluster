{
  pkgs,
  ...
}:

{
  packages = [
    pkgs.git
    pkgs.terraform
    pkgs.kubectl
    pkgs.k0sctl
  ];
  dotenv = {
    enable = true;
    filename = [
      ".env"
    ];
  };
}
