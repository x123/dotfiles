{pkgs, ...}: {
  imports = [];

  fonts.packages = [
    pkgs.nerdfonts
    pkgs.powerline-fonts
  ];
}
