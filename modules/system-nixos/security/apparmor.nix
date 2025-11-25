{
  config,
  lib,
  ...
}: {
  imports = [];

  options = {
    custom.system-nixos.security.apparmor = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable apparmor";
      };
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.security.apparmor.enable) {
    security = {
      apparmor.enable = true;
    };
  };
}
