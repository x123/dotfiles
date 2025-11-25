{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/user/common
    ../../modules/user/git.nix
    ../../modules/user/gpg-agent.nix
    ../../modules/user/shell
    ../../modules/user/editors/neovim.nix
  ];

  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;

  programs.ssh = {
    matchBlocks = {
      "me.github.com" = {
        hostname = "github.com";
        #user = "git";
        port = 22;
        identityFile = "/home/nixos/.ssh/id_wslnix";
        identitiesOnly = true;
      };
    };
  };
}
