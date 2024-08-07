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

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
  };
}
