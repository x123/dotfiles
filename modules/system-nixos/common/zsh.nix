{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];
  options = {
    custom.system-nixos.common.zsh.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable common zsh settings";
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.common.zsh.enable) {
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
