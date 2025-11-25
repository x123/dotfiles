{
  config,
  lib,
  ...
}: {
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

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.security.auditd.enable) {
    security = {
      auditd.enable = true;
    };
  };
}
