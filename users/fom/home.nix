{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../modules/user/alacritty
    ../../modules/user/common-packages.nix
    ../../modules/user/common-ssh.nix
    ../../modules/user/darwin/macos.nix
    ../../modules/user/darwin/safari.nix
    ../../modules/user/dev.nix
    ../../modules/user/git.nix
    ../../modules/user/shell
    ../../modules/user/video.nix
    ../../modules/user/neovim.nix
    ../../modules/user/desktop/keepass.nix
  ];

  home = {
    username = "fom";
    homeDirectory = "/Users/fom";
    stateVersion = "23.05";
    sessionVariables = {
      TESTINGVAR = "testing";
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
