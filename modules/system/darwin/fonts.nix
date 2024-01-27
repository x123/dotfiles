{pkgs, ...}: {
  imports = [];

  fonts.fontDir.enable = true;
  fonts.fonts = [
    pkgs.powerline-fonts
  ];
}
