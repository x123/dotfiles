{
  config,
  lib,
  ...
}: {
  options = {
    custom.system-nixos.services.qdrant = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system qdrant service";
      };
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.services.qdrant.enable) {
    services = {
      qdrant = {
        enable = true;
      };
    };
  };
}
