{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.security.auditd.enable) {
    security = {
      auditd.enable = true;
    };
  };
}
