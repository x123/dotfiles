{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./htop.nix
    ./starship.nix
    ./tmux.nix
    ./yazi.nix
    ./zoxide.nix
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

  home = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        file
        htop
        pciutils
        ripgrep
        ;
    };

    shellAliases = {
      nixium = "ssh nixium";
      ls = "ls --color";
      less = "less -mNg";
      nsp = "nix search nixpkgs";
      dns-cache-flush = "sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder";

      narsil-term = "narsil -mgcu -- -D -K -n4";
      # subset of oh-my-zsh aliases
      "ga" = "git add";
      "gaa" = "git add --all";
      "gapa" = "git add --patch";
      "gb" = "git branch";
      "gbd" = "git branch -d";
      "gbD" = "git branch -D";
      "gc" = "git commit -v";
      "gc!" = "git commit -v --amend";
      "gcn!" = "git commit -v --no-edit --amend";
      "gcan!" = "git commit -v -a --no-edit --amend";
      "gcb" = "git checkout -b";
      "gcm" = "git checkout master";
      "gcmsg" = "git commit -m";
      "gco" = "git checkout";
      "gd" = "git diff";
      "gds" = "git diff --staged";
      "gl" = "git pull";
      "glol" = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'";
      "gm" = "git merge";
      "gp" = "git push";
      "gpf" = "git push --force-with-lease";
      "gpf!" = "git push --force";
      "grs" = "git restore";
      "grst" = "git restore --staged";
      "gsh" = "git show";
      "gst" = "git status";
      # TODO: make this a script (to install terminfo on remotes)
      # "infocmp -x | ssh SOMEMACHINE -- tic -x -"
    };
  };
}
