{pkgs, ...}: {
  imports = [];

  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

}
