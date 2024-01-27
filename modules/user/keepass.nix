{pkgs, ...}: {
  imports = [];

  home = {
    packages = [
      pkgs.keepassxc
    ];
  };
}
