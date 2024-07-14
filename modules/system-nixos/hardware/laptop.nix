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

    services.logind = {
      lidSwitch = "hybrid-sleep";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
      powerKey = "ignore";
      powerKeyLongPress = "ignore";
    };

    systemd.sleep.extraConfig = "HibernateDelaySec=1h";
  };
}
