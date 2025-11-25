{pkgs, ...}: {
  imports = [
    ../../../../modules/user
    # ../../../../modules/user/ai
    # ../../../../modules/user/common
    # ../../../../modules/user/darwin
    # ../../../../modules/user/desktop
    # ../../../../modules/user/dev
    # ../../../../modules/user/editors
    # ../../../../modules/user/mail
    # ../../../../modules/user/shell
    # ../../../../modules/user/x11
  ];

  custom = {
    desktop = {
      enable = true;

      blender.enable = true;
      discord.enable = true;
      video.enable = true;
    };

    editors = {
      helix.enable = true;
      neovim.enable = true;
      vim.enable = false;
    };

    mail.enable = true;
  };

  home = {
    username = "x";
    homeDirectory = "/home/x";
    stateVersion = "23.05";
    sessionPath = [
      "$HOME/bin"
    ];
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
