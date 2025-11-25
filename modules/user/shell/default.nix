{pkgs, config, ...}: {
  imports = [
    ./fonts.nix
    ./htop.nix
    ./tmux.nix
    ./starship.nix
  ];

  programs.dircolors = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
    };
    extraConfig = builtins.readFile (
      pkgs.fetchFromGitHub {
        owner = "nordtheme";
        repo = "dircolors";
        rev = "2f5b939274d6a8e99a5c94fac0e57a100dc323c7";
        sha256 = "2t+ETXqqidEqs0uvR/MNZlMqVJErEiBGADVujDplvpU=";
      } + "/src/dir_colors"
    );
  };

  home = {
    packages = with pkgs; [
      # term/shell
      file
      htop
      pciutils
      ripgrep
    ];

    shellAliases = {
      adamantium = "ssh adamantium";
      boxchop = "ssh adamantium";
      ls = "ls --color";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '' + ''
     function set_win_title(){
       echo -ne "\033]0; $(basename "$PWD") \007"
     }
     starship_precmd_user_func="set_win_title"
    '';
  };

}
