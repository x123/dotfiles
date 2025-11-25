{pkgs, ...}: {
  imports = [];

  environment.systemPackages = [
    pkgs.cifs-utils
  ];
}
