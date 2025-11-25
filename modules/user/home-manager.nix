{pkgs, ...}: {
  imports = [];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

#  home.packages = with pkgs; [
#    home-manager
#  ];

}
