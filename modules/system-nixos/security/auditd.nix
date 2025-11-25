{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  options = {
    custom.system-nixos.security.auditd = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable auditd";
      };
    };
  };

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.security.auditd.enable) {
    security = {
      auditd.enable = true;
    };
  };
}
