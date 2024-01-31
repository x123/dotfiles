{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/user/common
    ../../modules/user/dev.nix
    ../../modules/user/git.nix
    ../../modules/user/shell
    ../../modules/user/editors/neovim.nix
  ];

  home = {
    username = "root";
    homeDirectory = "/root";
    stateVersion = "24.05";
    sessionPath = [
      "$HOME/bin"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowAliases = false;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [pkgs.home-manager];

  programs.ssh = {
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        port = 22;
        identityFile = "/run/secrets/ssh/nixium/private";
        #identityFile = "~/.ssh/id_nixium";
        identitiesOnly = true;
      };
    };
  };
}
