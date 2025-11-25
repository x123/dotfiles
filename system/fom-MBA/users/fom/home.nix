{lib, ...}: {
  imports = [
    ../../../../modules/user/common
    ../../../../modules/user/darwin
    ../../../../modules/user/dev
    ../../../../modules/user/shell
    ../../../../modules/user/desktop/alacritty
    ../../../../modules/user/desktop/video.nix
    ../../../../modules/user/editors/neovim.nix
    ../../../../modules/user/desktop/keepass.nix
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
