{lib, ...}: {
  imports = [
    ../../../../modules/user
  ];

  custom = {
    desktop = {
      enable = true;

      blender.enable = false;
      gimp.enable = true;
      video.enable = true;
    };

    games.enable = true;

    user = {
      editors = {
        emacs.enable = false;
        helix.enable = false;
        neovim.enable = true;
        vim.enable = false;
        vscode.enable = true;
      };

      mail.enable = false;
    };
  };

  home = {
    username = "fom";
    homeDirectory = "/Users/fom";
    stateVersion = "23.05";
    sessionVariables = {
      TESTINGVAR = "testing";
    };

    shellAliases = {
      "todo!" = "cd ~/work/src/todo; sops todo.md";
    };
  };

  programs = {
    # force override the font size for alacritty
    alacritty = {
      settings = {
        font = {
          size = lib.mkForce 16;
        };
      };
    };

    home-manager.enable = true;

    ssh = {
      includes = [
        "config.d/*"
      ];
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          port = 22;
          identityFile = "/Users/fom/.ssh/id_fom-mba-work";
          identitiesOnly = true;
        };
        "me.github.com" = {
          hostname = "github.com";
          port = 22;
          identityFile = "/Users/fom/.ssh/id_fom-mba";
          identitiesOnly = true;
        };
        "work.github.com" = {
          hostname = "github.com";
          port = 22;
          identityFile = "/Users/fom/.ssh/id_fom-mba-work";
          identitiesOnly = true;
        };
        "hetznix" = {
          hostname = "hetznix.nixlink.net";
          port = 22;
          user = "root";
          identityFile = "/Users/fom/.ssh/id_fom-mba";
          identitiesOnly = true;
        };
        "hetznix.nixlink.net" = {
          hostname = "hetznix.nixlink.net";
          port = 22;
          user = "root";
          identityFile = "/Users/fom/.ssh/id_fom-mba";
          identitiesOnly = true;
        };
        "xnix.empire.internal" = {
          hostname = "xnix.empire.internal";
          port = 22;
          addressFamily = "inet";
          user = "x";
          identityFile = "/Users/fom/.ssh/id_fom-mba";
          identitiesOnly = true;
        };
        "nixpad.empire.internal" = {
          hostname = "nixpad.empire.internal";
          port = 22;
          addressFamily = "inet";
          user = "x";
          identityFile = "/Users/fom/.ssh/id_fom-mba";
          identitiesOnly = true;
        };
      };
    };
  };
}
