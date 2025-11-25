{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  options = {
    custom.system-v2.services.jellyfin = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system jellyfin service";
      };
    };
  };

  config = lib.mkIf (cfg.system-v2.enable && cfg.system-v2.services.jellyfin.enable) {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
  };
}
