{
  inputs,
  pkgs,
  system,
  config,
  lib,
  ...
}: {
  imports = [
    ./aliases.nix
    ./btop.nix
    ./common-packages.nix
    ./crypto.nix
    ./fonts.nix
    ./htop.nix
    ./network.nix
    ./presenterm.nix
    ./scripts.nix
    ./sec.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./zoxide.nix
  ];

  options = {
    custom.user.shell = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable shell environment";
      };
    };
  };

  config = lib.mkIf config.custom.user.shell.enable {
    nixpkgs.overlays = [
      (
        final: prev: {
          x123 = import inputs.nixpkgs-x123 {
            inherit system;
          };
        }
      )
    ];

    programs = {
      dircolors = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        settings = {};
        extraConfig = builtins.readFile (
          pkgs.fetchFromGitHub
          {
            owner = "nordtheme";
            repo = "dircolors";
            rev = "2f5b939274d6a8e99a5c94fac0e57a100dc323c7";
            sha256 = "2t+ETXqqidEqs0uvR/MNZlMqVJErEiBGADVujDplvpU=";
          }
          + "/src/dir_colors"
        );
      };
      atuin = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        settings = {
          enter_accept = false;
          keymap_mode = "vim-normal";
        };
      };

      bat = {
        enable = true;
        config = {
          pager = "less -mg";
          theme = "Nord";
          paging = "never";
        };
      };

      eza = {
        enable = true;
        extraOptions = [
          "-lag@Zb"
          "--time-style=long-iso"
          "--color=never"
        ];
      };

      zsh = {
        enable = true;
        enableCompletion = true;

        oh-my-zsh = {
          enable = false;
          plugins = [
            "git"
            "sudo"
            "rsync"
          ];
        };
        envExtra = ''
          export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
        '';
      };

      bash = {
        enable = true;
        enableCompletion = true;
        bashrcExtra =
          ''
            export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
          ''
          + ''
            function set_win_title(){
              echo -ne "\033]0; $(basename "$PWD") \007"
            }
            starship_precmd_user_func="set_win_title"
          '';
      };
    };
  };
}
