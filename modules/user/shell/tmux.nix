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
      # Set true color
      set-option -sa terminal-overrides ",xterm*:Tc"

      # Keep CWD on splits
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # Smart pane switching with awareness of Vim splits.
	  # See: https://github.com/christoomey/vim-tmux-navigator
	  is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^.*vim.*$'"

      bind-key -n 'C-Left' if-shell "$is_vim" { send-keys C-Left }  { select-pane -L }
      bind-key -n 'C-Down' if-shell "$is_vim" { send-keys C-Down }  { select-pane -D }
      bind-key -n 'C-Up' if-shell "$is_vim" { send-keys C-Up }  { select-pane -U }
      bind-key -n 'C-Right' if-shell "$is_vim" { send-keys C-Right }  { select-pane -R }

	  bind-key -T copy-mode-vi 'C-Left' select-pane -L
	  bind-key -T copy-mode-vi 'C-Down' select-pane -D
	  bind-key -T copy-mode-vi 'C-Up' select-pane -U
	  bind-key -T copy-mode-vi 'C-Right' select-pane -R
    '';
    plugins = with pkgs; [
      tmuxPlugins.nord
      #tmuxPlugins.vim-tmux-navigator
    ];
  };

}
