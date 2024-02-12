{pkgs, ...}: {
  imports = [];

  fonts.fontDir.enable = true;
  fonts.fonts = [
    pkgs.nerdfonts
    pkgs.powerline-fonts
  ];
}
