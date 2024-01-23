{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/user/binrich.nix
    ../../modules/user/common-packages.nix
    ../../modules/user/common-ssh.nix
    ../../modules/user/dev.nix
    ../../modules/user/git.nix
    ../../modules/user/neovim.nix
    ../../modules/user/shell
    ../../modules/user/systemd/service-binrich.nix
  ];

  home = {
    username = "binrich";
    homeDirectory = "/home/binrich";
    stateVersion = "24.05";
    sessionPath = [
      "$HOME/bin"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    home-manager
    #inputs.binrich.packages.${pkgs.stdenv.hostPlatform.system}.binrich
  ];

  # programs.ssh = {
  #   matchBlocks = {
  #     "github.com" = {
  #       hostname = "github.com";
  #       port = 22;
  #       identityFile = "/run/secrets/ssh/nixium/private";
  #       #identityFile = "~/.ssh/id_nixium";
  #       identitiesOnly = true;
  #     };
  #   };
  # };

}
