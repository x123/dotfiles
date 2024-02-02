{lib, ...}: {
  imports = [
    ../../../../modules/user
  ];

  custom = {
    desktop = {
      enable = true;

      blender.enable = false;
      video.enable = true;
    };

    editors = {
      helix.enable = false;
      neovim.enable = true;
      vim.enable = false;
    };

    mail.enable = false;
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
          size = lib.mkForce 14;
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
        "nixium" = {
          hostname = "nixium.boxchop.city";
          port = 22;
          user = "root";
          identityFile = "/Users/fom/.ssh/id_fom-mba";
          identitiesOnly = true;
        };
        "nixium.boxchop.city" = {
          hostname = "nixium.boxchop.city";
          port = 22;
          user = "root";
          identityFile = "/Users/fom/.ssh/id_fom-mba";
          identitiesOnly = true;
        };
      };
    };
  };
}
