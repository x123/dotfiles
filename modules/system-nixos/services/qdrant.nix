{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  options = {
    custom.system-nixos.services.qdrant = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system qdrant service";
      };
    };
  };

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.services.qdrant.enable) {
    services = {
      qdrant = {
        enable = true;
      };
    };
  };
}
