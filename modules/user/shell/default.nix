{pkgs, ...}: {
  imports = [
    ./tmux.nix
    ./starship.nix
  ];

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
