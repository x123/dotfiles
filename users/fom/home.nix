{pkgs, inputs, lib, ...}: {
  imports = [
    ../../modules/user/alacritty
    ../../modules/user/darwin/common-packages.nix
    ../../modules/user/darwin/common-ssh.nix
    ../../modules/user/darwin/macos.nix
    ../../modules/user/darwin/safari.nix
    ../../modules/user/git.nix
    ../../modules/user/shell
    ../../modules/user/vim.nix
    ../../modules/user/keepass.nix
  ];

  # force override the font size for alacritty
  programs.alacritty = {
    settings = {
      font = {
        size = lib.mkForce 14;
      };
    };
  };

  home = {
    username = "fom";
    homeDirectory = "/Users/fom";
    stateVersion = "23.05";
    sessionVariables = {
      TESTINGVAR = "testing";
    };
  };

  programs.home-manager.enable = true;

  programs.ssh = {
    matchBlocks = {
      "adamantium" = {
        hostname = "adamantium.boxchop.city";
        user = "root";
        port = 2222;
        identityFile = "/Users/fom/.ssh/id_fom-mba";
      };
      "me.github.com" = {
        hostname = "github.com";
        port = 22;
        identityFile = "/Users/fom/.ssh/id_fom-mba";
      };
    };
  };

}
