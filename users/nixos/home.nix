{pkgs, ...}: {
  imports = [
    ../modules/common-packages.nix
    ../modules/common-ssh.nix
    ../modules/git.nix
    ../modules/gpg-agent.nix
    ../modules/shell.nix
    ../modules/vim.nix
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
