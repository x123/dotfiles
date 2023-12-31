{ pkgs, config, ... }: {
  imports = [
    ./fonts.nix
    ./htop.nix
    ./starship.nix
    ./tmux.nix
    ./yazi.nix
    ./zoxide.nix
  ];

  programs.dircolors = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = { };
    extraConfig = builtins.readFile (
      pkgs.fetchFromGitHub
        {
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
      nixium = "ssh nixium";
      ls = "ls --color";
      less = "less -mNg";
      nsp = "nix search nixpkgs";
      dns-cache-flush = "sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder";
      y = "yazi";
      # TODO: make this a script (to install terminfo on remotes)
      # "infocmp -x | ssh SOMEMACHINE -- tic -x -"
    };
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = {
      pager = "less -mg";
      theme = "Nord";
      paging = "never";
    };
  };

  programs.eza = {
    enable = true;
    extraOptions = [
      "-lag@Zb"
      "--time-style=long-iso"
      "--color=never"
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "rsync"
      ];
    };
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
