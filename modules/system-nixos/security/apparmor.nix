{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
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

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.security.apparmor.enable) {
    security = {
      apparmor.enable = true;
    };
  };
}
