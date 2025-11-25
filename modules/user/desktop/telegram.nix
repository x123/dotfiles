{pkgs, ...}: {
  imports = [];

  home = {
    packages = [
      pkgs.telegram-desktop
    ];
  };
}
