{pkgs, ...}: {
  imports = [
    ../../modules/user/darwin/alacritty.nix
    ../../modules/user/darwin/common-packages.nix
    ../../modules/user/darwin/common-ssh.nix
    ../../modules/user/darwin/control-center.nix
    ../../modules/user/git.nix
    ../../modules/user/shell.nix
    ../../modules/user/vim.nix
  ];

  home = {
    username = "fom";
    homeDirectory = "/Users/fom";
    stateVersion = "23.05";
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
