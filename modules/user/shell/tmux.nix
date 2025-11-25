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
    extraConfig = ''
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
    plugins = with pkgs; [
      tmuxPlugins.nord
    ];
  };

}
