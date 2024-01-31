{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    #../../modules/user/ai/pytorch.nix
    #../../modules/user/ai/invokeai.nix
    ../../modules/user/desktop/alacritty
    ../../modules/user/desktop/blender.nix
    ../../modules/user/desktop/calibre.nix
    ../../modules/user/desktop/chromium.nix
    ../../modules/user/common
    ../../modules/user/dev
    ../../modules/user/desktop/discord.nix
    ../../modules/user/desktop/firefox.nix
    ../../modules/user/desktop/ghostty.nix
    ../../modules/user/editors/helix.nix
    ../../modules/user/desktop/keepass.nix
    ../../modules/user/neomutt.nix
    ../../modules/user/editors/neovim.nix
    ../../modules/user/shell
    ../../modules/user/desktop/telegram.nix
    ../../modules/user/desktop/tor-browser.nix
    ../../modules/user/desktop/video.nix
    ../../modules/user/x11
    ../../modules/user/desktop/yed.nix
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

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      # net
      
      persepolis
      dropbox
      # office
      
      libreoffice
      # art
      
      gimp
      # misc
      
      xygrib
      ;
  };

  programs.ssh = {
    matchBlocks = {
      "me.github.com" = {
        hostname = "github.com";
        port = 22;
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
        checkHostIP = false;
        extraOptions = {
          StrictHostKeyChecking = "no";
        };
      };
      "nixium.boxchop.city" = {
        hostname = "nixium.boxchop.city";
        port = 22;
        user = "root";
        identityFile = "/home/x/.ssh/id_xnix";
        identitiesOnly = true;
        checkHostIP = false;
        extraOptions = {
          StrictHostKeyChecking = "no";
        };
      };
    };
  };
}
