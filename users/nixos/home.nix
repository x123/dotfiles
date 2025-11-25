{pkgs, inputs, ...}: {
  imports = [
    ../../modules/user/common-packages.nix
    ../../modules/user/common-ssh.nix
    ../../modules/user/git.nix
    ../../modules/user/gpg-agent.nix
    ../../modules/user/shell
    ../../modules/user/vim.nix
  ];

  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;

  programs.ssh = {
    matchBlocks = {
      "adamantium" = {
        hostname = "adamantium.boxchop.city";
        user = "root";
        port = 2222;
        identityFile = "/home/nixos/.ssh/id_wslnix";
      };
      "me.github.com" = {
        hostname = "github.com";
        #user = "git";
        port = 22;
        identityFile = "/home/nixos/.ssh/id_wslnix";
      };
    };
  };

}
