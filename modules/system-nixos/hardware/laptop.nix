{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.hardware.laptop.enable) {
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };

    systemd.sleep.extraConfig = "HibernateDelaySec=1h";
  };
}
