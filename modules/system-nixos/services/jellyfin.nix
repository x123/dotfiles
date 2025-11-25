{
  config,
  lib,
  ...
}: {
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

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.services.jellyfin.enable) {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
  };
}
