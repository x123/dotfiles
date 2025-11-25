{pkgs, ...}: {
  imports = [];

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

}
