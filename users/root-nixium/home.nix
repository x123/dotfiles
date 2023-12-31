{ config, pkgs, inputs, ... }:

{
  imports = [
    #<sops-nix/modules/home-manager/sops.nix>
    #../../modules/user/ai.nix
    #../../modules/user/alacritty
    #../../modules/user/blender.nix
    #../../modules/user/calibre.nix
    #../../modules/user/chromium.nix
    ../../modules/user/common-packages.nix
    ../../modules/user/common-ssh.nix
    ../../modules/user/dev.nix
    #../../modules/user/discord.nix
    #../../modules/user/firefox.nix
    ../../modules/user/git.nix
    #../../modules/user/gpg-agent.nix
    #../../modules/user/keepass.nix
    #../../modules/user/pytorch.nix
    ../../modules/user/shell
    #../../modules/user/tor-browser.nix
    #../../modules/user/video.nix
    ../../modules/user/neovim.nix
    #../../modules/user/x11
  ];

  home = {
    username = "root";
    homeDirectory = "/root";
    stateVersion = "24.05";
    sessionPath = [
      "$HOME/bin"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    home-manager
  ];

  programs.ssh = {
    matchBlocks = {
      "adamantium" = {
        hostname = "adamantium.boxchop.city";
        user = "root";
        port = 2222;
        identityFile = "/run/secrets/ssh/nixium/private";
        #identityFile = "~/.ssh/id_nixium";
        identitiesOnly = true;
      };
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
