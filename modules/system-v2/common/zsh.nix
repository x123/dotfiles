{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-v2.enable && cfg.system-v2.common.zsh.enable) {
    environment.systemPackages = [
      pkgs.zsh
    ];

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
  };
}
