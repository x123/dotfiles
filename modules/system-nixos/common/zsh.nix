{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.common.zsh.enable) {
    environment.systemPackages = [
      pkgs.zsh
    ];

    programs.zsh = {
      enable = true;
      setOptions = [
        "HIST_IGNORE_DUPS"
        "SHARE_HISTORY"
        "HIST_FCNTL_LOCK"
        "EXTENDED_HISTORY"
        "VI"
      ];
      interactiveShellInit = ''
        bindkey '^R' history-incremental-search-backward
      '';
    };
    users.defaultUserShell = pkgs.zsh;
  };
}
