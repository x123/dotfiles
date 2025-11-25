{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.system-darwin.stats = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable stats";
      };
    };
  };

  config = lib.mkIf (config.custom.system-darwin.enable && config.custom.system-darwin.stats.enable) {
    environment.systemPackages = [
      pkgs.stats
    ];
  };
}
