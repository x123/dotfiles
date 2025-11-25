{...}: {
  imports = [
    ../../../../modules/user/common
    ../../../../modules/user/shell
    ../../../../modules/user/dev
    ../../../../modules/user/editors/neovim.nix
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
