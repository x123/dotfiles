{pkgs, ...}: {
  imports = [];

  # 2024-10-12
  # tmux in nixpkgs newer than 3.4 breaks default shell in darwin environments
  # https://github.com/NixOS/nixpkgs/commit/80931ba844da56228943f61b655a061f7f8a06a3
  nixpkgs.overlays = [
    (
      final: prev: {
        tmux = prev.tmux.overrideAttrs (
          old: {
            version = "3.4";
            src = prev.fetchFromGitHub {
              owner = "tmux";
              repo = "tmux";
              rev = "3.4";
              version = "3.4";
              hash = "sha256-RX3RZ0Mcyda7C7im1r4QgUxTnp95nfpGgQ2HRxr0s64=";
            };
            patches = [
              (prev.fetchpatch {
                url = "https://github.com/tmux/tmux/commit/2d1afa0e62a24aa7c53ce4fb6f1e35e29d01a904.diff";
                hash = "sha256-mDt5wy570qrUc0clGa3GhZFTKgL0sfnQcWJEJBKAbKs=";
              })
              # this patch is designed for android but FreeBSD exhibits the same error for the same reason
              (prev.fetchpatch {
                url = "https://github.com/tmux/tmux/commit/4f5a944ae3e8f7a230054b6c0b26f423fa738e71.patch";
                hash = "sha256-HlUeU5ZicPe7Ya8A1HpunxfVOE2BF6jOHq3ZqTuU5RE=";
              })
              # https://github.com/tmux/tmux/issues/3983
              # fix tmux crashing when neovim is used in a ssh session
              (prev.fetchpatch {
                url = "https://github.com/tmux/tmux/commit/aa17f0e0c1c8b3f1d6fc8617613c74f07de66fae.patch";
                hash = "sha256-jhWGnC9tsGqTTA5tU+i4G3wlwZ7HGz4P0UHl17dVRU4=";
              })
              # https://github.com/tmux/tmux/issues/3905
              # fix tmux hanging on shutdown
              (prev.fetchpatch {
                url = "https://github.com/tmux/tmux/commit/3823fa2c577d440649a84af660e4d3b0c095d248.patch";
                hash = "sha256-FZDy/ZgVdwUAam8g5SfGBSnMhp2nlHHfrO9eJNIhVPo=";
              })
            ];
          }
        );
      }
    )
  ];

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
