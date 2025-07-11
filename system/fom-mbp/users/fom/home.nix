{
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../../../modules/user
  ];

  nixpkgs.overlays = [
    (
      final: prev: {
        unstable-small = import inputs.nixpkgs-unstable-small {
          system = "x86_64-linux";
        };
      }
    )
  ];

  custom = {
    desktop = {
      enable = true;

      blender.enable = false;
      gimp.enable = true;
      video.enable = true;
      keepassxc.enable = true;
    };

    editors = {
      helix.enable = false;
      neovim.enable = true;
      vim.enable = false;
    };

    games.enable = true;
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
          identityFile = "/Users/fom/.ssh/id_fom-mbp-work";
          identitiesOnly = true;
        };
        "me.github.com" = {
          hostname = "github.com";
          port = 22;
          identityFile = "/Users/fom/.ssh/id_fom-mbp-priv";
          identitiesOnly = true;
        };
        "work.github.com" = {
          hostname = "github.com";
          port = 22;
          identityFile = "/Users/fom/.ssh/id_fom-mbp-work";
          identitiesOnly = true;
        };
        "hetznix" = {
          hostname = "hetznix.nixlink.net";
          port = 22;
          user = "root";
          identityFile = "/Users/fom/.ssh/id_fom-mbp-priv";
          identitiesOnly = true;
        };
        "hetznix.nixlink.net" = {
          hostname = "hetznix.nixlink.net";
          port = 22;
          user = "root";
          identityFile = "/Users/fom/.ssh/id_fom-mbp-priv";
          identitiesOnly = true;
        };
        "xnix.empire.internal" = {
          hostname = "xnix.empire.internal";
          port = 22;
          addressFamily = "inet";
          user = "x";
          identityFile = "/Users/fom/.ssh/id_fom-mbp-priv";
          identitiesOnly = true;
        };
        "nixpad.empire.internal" = {
          hostname = "nixpad.empire.internal";
          port = 22;
          addressFamily = "inet";
          user = "x";
          identityFile = "/Users/fom/.ssh/id_fom-mbp-priv";
          identitiesOnly = true;
        };
      };
    };
  };
}
