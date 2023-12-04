{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/user/ai.nix
    ../../modules/user/alacritty
    ../../modules/user/blender.nix
    ../../modules/user/common-packages.nix
    ../../modules/user/common-ssh.nix
    ../../modules/user/discord.nix
    ../../modules/user/firefox.nix
    ../../modules/user/git.nix
    ../../modules/user/gpg-agent.nix
    ../../modules/user/keepass.nix
    #../../modules/user/pytorch.nix
    ../../modules/user/shell
    ../../modules/user/tor-browser.nix
    ../../modules/user/video.nix
    ../../modules/user/vim.nix
    ../../modules/user/x11
  ];

  home = {
    username = "x";
    homeDirectory = "/home/x";
    stateVersion = "23.05";
  };
  nixpkgs.config.allowUnfree = true;

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
