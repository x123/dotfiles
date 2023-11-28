{ config, pkgs, ... }:

{
  imports = [
    ../modules/alacritty.nix
    ../modules/common-packages.nix
    ../modules/common-ssh.nix
    ../modules/firefox.nix
    ../modules/git.nix
    ../modules/gpg-agent.nix
    ../modules/shell.nix
    ../modules/vim.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "x";
  home.homeDirectory = "/home/x";
  home.sessionVariables = {
    #EDITOR = "vim";
  };
  home.stateVersion = "23.05"; # dont change

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # discord
  nixpkgs.overlays = [(
    self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
          sha256 = "1xjk77g9lj5b78c1w3fj42by9b483pkbfb41yzxrg4p36mnd2hkn";
        }; }
      );
    }
    )
  ];

  home.packages = with pkgs; [
    # term/shell
    alacritty

    # net
    persepolis
    discord
    dropbox

    # office
    libreoffice

    # audio/video
    pavucontrol
    streamlink
    vlc

    # art
    gimp

    # crypto
    keepassxc

    # misc
    xygrib
  ];

  programs.yt-dlp = {
    enable = true;
    settings = {
      embed-thumbnail = true;
      embed-subs = true;
      sub-langs = "all";
      downloader = "aria2c";
      downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
    };
  };

  programs.ssh = {
    matchBlocks = {
      "adamantium" = {
        hostname = "adamantium.boxchop.city";
        user = "root";
        port = 2222;
        identityFile = "/home/x/.ssh/id_xbox";
      };
      "github.com" = {
        hostname = "github.com";
        port = 22;
        identityFile = "/home/x/.ssh/id_xbox";
      };
    };
  };

}
