{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../modules/user/alacritty
    ../../modules/user/common-packages.nix
    ../../modules/user/common-ssh.nix
    ../../modules/user/firefox.nix
    ../../modules/user/git.nix
    ../../modules/user/gpg-agent.nix
    ../../modules/user/keepass.nix
    ../../modules/user/shell
    #../../modules/user/tor-browser.nix
    #../../modules/user/video.nix
    ../../modules/user/vim.nix
    ../../modules/user/x11
  ];

  # force rofi font size for hidpi
  programs.rofi = lib.mkForce {
    font = "Fira Mono for Powerline 20";
  };

  # force alacritty font size for hidpi
  programs.alacritty = lib.mkForce {
    settings = {
      font = {
        size = 20;
      };
    };
  };

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
        identityFile = "/home/x/.ssh/id_fom-mba-utm-vm";
      };
      "me.github.com" = {
        hostname = "github.com";
        port = 22;
        identityFile = "/home/x/.ssh/id_fom-mba-utm-vm";
      };
    };
  };

}
