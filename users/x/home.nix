{ config, pkgs, ... }:

{
  imports = [
    ../modules/alacritty.nix
    ../modules/common-packages.nix
    ../modules/common-ssh.nix
    ../modules/firefox.nix
    ../modules/git.nix
    ../modules/gpg-agent.nix
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

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
    shellAliases = {
      adamantium = "ssh adamantium";
      boxchop = "ssh adamantium";
    };
  };

  programs.starship.enable = true;
  programs.starship.enableBashIntegration = true;
  programs.starship.settings = {
    add_newline = false;
    format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
    shlvl = {
      disabled = false;
      symbol = "ﰬ";
      style = "bright-red bold";
    };
    shell = {
      disabled = false;
      format = "$indicator";
      fish_indicator = "";
      bash_indicator = "[bash](bright-white) ";
      zsh_indicator = "[zsh](bright-white) ";
    };
    username = {
      style_user = "bright-white bold";
      style_root = "bright-red bold";
    };
    hostname = {
      style = "bright-green bold";
      ssh_only = true;
    };
    nix_shell = {
      symbol = "";
      format = "[$symbol$name]($style) ";
      style = "bright-purple bold";
    };
    git_branch = {
      only_attached = true;
      format = "[$symbol$branch]($style) ";
      symbol = "שׂ";
      style = "bright-yellow bold";
    };
    git_commit = {
      only_detached = true;
      format = "[ﰖ$hash]($style) ";
      style = "bright-yellow bold";
    };
    git_state = {
      style = "bright-purple bold";
    };
    git_status = {
      style = "bright-green bold";
    };
    directory = {
      read_only = " ";
      truncation_length = 0;
    };
    cmd_duration = {
      format = "[$duration]($style) ";
      style = "bright-blue";
    };
    jobs = {
      style = "bright-green bold";
    };
    character = {
      success_symbol = "[\\$](bright-green bold)";
      error_symbol = "[\\$](bright-red bold)";
    };
  };

}
