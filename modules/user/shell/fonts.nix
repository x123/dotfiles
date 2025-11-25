{pkgs, ...}: {
  imports = [];

  fonts.fontconfig.enable = true;

  home = {
    packages = [
      pkgs.powerline-fonts
    ];
  };
}
