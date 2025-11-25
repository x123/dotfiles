{pkgs, ...}: {
  imports = [];

  home = {
    packages = with pkgs; [
      keepassxc
    ];
  };
}
