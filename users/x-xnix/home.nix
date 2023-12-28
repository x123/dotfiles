{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/user/ai.nix
    ../../modules/user/alacritty
    ../../modules/user/blender.nix
    ../../modules/user/calibre.nix
    ../../modules/user/chromium.nix
    ../../modules/user/common-packages.nix
    ../../modules/user/common-ssh.nix
    ../../modules/user/dev.nix
    ../../modules/user/discord.nix
    ../../modules/user/firefox.nix
    ../../modules/user/git.nix
    ../../modules/user/gpg-agent.nix
    ../../modules/user/home-manager.nix
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
    sessionPath = [
      "$HOME/bin"
    ];
  };

  home.file = {
    mount-kobo = {
      enable = true;
      #executable = true;
      source = ./files/mount-kobo;
      target = "bin/mount-kobo";
    };

    unmount-kobo = {
      enable = true;
      #executable = true;
      source = ./files/unmount-kobo;
      target = "bin/unmount-kobo";
    };
  };

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
      "nixium" = {
        hostname = "nixium.boxchop.city";
        port = 22;
        user = "root";
        identityFile = "/home/x/.ssh/id_xnix";
      };
      "nixium.boxchop.city" = {
        hostname = "nixium.boxchop.city";
        port = 22;
        user = "root";
        identityFile = "/home/x/.ssh/id_xnix";
      };
    };
  };

}
