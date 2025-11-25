{pkgs, ...}: {
  imports = [];

  programs.tmux = {
    enable = true;
    historyLimit = 100000;
    mouse = true;
    keyMode = "vi";
    clock24 = true;
    shortcut = "a";
    plugins = with pkgs; [
      tmuxPlugins.nord
    ];
  };

}
