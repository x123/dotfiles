{
  pkgs,
  inputs,
  ...
}: {
  imports = [];

  # packages
  home.packages = [
    pkgs.yed
  ];
}
