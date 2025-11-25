{pkgs, ...}: {
  imports = [];

  programs.tmux = {
    enable = true;
    historyLimit = 100000;
    mouse = true;
    keyMode = "vi";
    clock24 = true;
    shortcut = "Space";
    baseIndex = 1;
    aggressiveResize = true;
    plugins = with pkgs; [
      tmuxPlugins.nord
    ];
  };

}
