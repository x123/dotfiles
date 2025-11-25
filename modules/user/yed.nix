{
  pkgs,
  inputs,
  ...
}: {
  imports = [];

  # packages
  home.packages = with pkgs; [
    yed
  ];
}
