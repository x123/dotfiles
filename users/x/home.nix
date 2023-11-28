{ config, pkgs, ... }:

{
  imports = [
    ../modules/alacritty.nix
    ../modules/common-packages.nix
    ../modules/common-ssh.nix
    ../modules/discord.nix
    ../modules/firefox.nix
    ../modules/git.nix
    ../modules/gpg-agent.nix
    ../modules/shell.nix
    ../modules/video.nix
    ../modules/vim.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "x";
  home.homeDirectory = "/home/x";
  home.sessionVariables = {
    #EDITOR = "vim";
  };
  home.stateVersion = "23.05"; # dont change

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # net
    persepolis
    dropbox

    # office
    libreoffice

    # art
    gimp

    # crypto
    keepassxc

    # misc
    xygrib
  ];

  programs.ssh = {
    matchBlocks = {
      "adamantium" = {
        hostname = "adamantium.boxchop.city";
        user = "root";
        port = 2222;
        identityFile = "/home/x/.ssh/id_xbox";
      };
      "github.com" = {
        hostname = "github.com";
        port = 22;
        identityFile = "/home/x/.ssh/id_xbox";
      };
    };
  };

}
