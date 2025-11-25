{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  options = {
    custom.system-darwin.stats = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable stats";
      };
    };
  };

  config = lib.mkIf (cfg.system-darwin.enable && cfg.system-darwin.stats.enable) {
    environment.systemPackages = [
      pkgs.stats
    ];
  };
}
