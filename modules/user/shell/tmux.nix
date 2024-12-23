{pkgs, ...}: {
  imports = [];

  programs.tmux = {
    enable = true;
    historyLimit = 100000;
    mouse = true;
    keyMode = "vi";
    clock24 = true;
    shortcut = "b";
    baseIndex = 1;
    aggressiveResize = true;
    extraConfig = ''
      # required to fix tmux 3.5a bug with tmux-sensible
      set -gu default-command
      set -g default-shell "$SHELL"

      # Set true color
      set-option -a terminal-features "*:RGB,mouse,sync"
      #set-option -sa terminal-overrides ",xterm*:Tc"
      set-option -g default-terminal "tmux-256color"

      set-option -g bell-action none
      set-option -g visual-bell off
      set-option -sg escape-time 10

      # Keep CWD on splits
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^.*vim.*$'"

      bind-key -n 'C-h' if-shell "$is_vim" { send-keys C-h }  { select-pane -L }
      bind-key -n 'C-j' if-shell "$is_vim" { send-keys C-j }  { select-pane -D }
      bind-key -n 'C-k' if-shell "$is_vim" { send-keys C-k }  { select-pane -U }
      bind-key -n 'C-l' if-shell "$is_vim" { send-keys C-l }  { select-pane -R }

      bind-key -n 'C-Left' if-shell "$is_vim" { send-keys C-Left }  { select-pane -L }
      bind-key -n 'C-Down' if-shell "$is_vim" { send-keys C-Down }  { select-pane -D }
      bind-key -n 'C-Up' if-shell "$is_vim" { send-keys C-Up }  { select-pane -U }
      bind-key -n 'C-Right' if-shell "$is_vim" { send-keys C-Right }  { select-pane -R }

      bind-key -T copy-mode-vi 'C-Left' select-pane -L
      bind-key -T copy-mode-vi 'C-Down' select-pane -D
      bind-key -T copy-mode-vi 'C-Up' select-pane -U
      bind-key -T copy-mode-vi 'C-Right' select-pane -R
    '';

    plugins = [
      pkgs.tmuxPlugins.nord
    ];
  };
}
