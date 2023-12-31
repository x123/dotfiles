{ config, pkgs, inputs, ... }:

{
  imports = [
    #../../modules/user/pytorch.nix
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
    ../../modules/user/ghostty.nix
    ../../modules/user/git.nix
    ../../modules/user/gpg-agent.nix
    ../../modules/user/home-manager.nix
    ../../modules/user/keepass.nix
    ../../modules/user/neovim.nix
    ../../modules/user/shell
    ../../modules/user/systemd/timer-monitor-nixium.nix
    ../../modules/user/systemd/timer-monitor-binrich.nix
    ../../modules/user/tor-browser.nix
    ../../modules/user/video.nix
    ../../modules/user/x11
    ../../modules/user/yed.nix
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
        identitiesOnly = true;
      };
      "github.com" = {
        hostname = "github.com";
        port = 22;
        identityFile = "/home/x/.ssh/id_xbox";
        identitiesOnly = true;
      };
      "nixium" = {
        hostname = "nixium.boxchop.city";
        port = 22;
        user = "root";
        identityFile = "/home/x/.ssh/id_xnix";
        identitiesOnly = true;
      };
      "nixium.boxchop.city" = {
        hostname = "nixium.boxchop.city";
        port = 22;
        user = "root";
        identityFile = "/home/x/.ssh/id_xnix";
        identitiesOnly = true;
      };
    };
  };

}
