{pkgs, ...}: {
  imports = [];

  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      powerline-fonts
    ];
  };

}
