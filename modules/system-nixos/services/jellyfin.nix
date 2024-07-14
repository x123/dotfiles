{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  options = {
    custom.system-nixos.services.jellyfin = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system jellyfin service";
      };
    };
  };

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.services.jellyfin.enable) {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
  };
}
