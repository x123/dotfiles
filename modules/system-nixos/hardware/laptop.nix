{
  config,
  lib,
  ...
}: {
  imports = [];

  options = {
    custom.system-nixos.hardware.laptop.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable system laptop hardware & packages";
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.hardware.laptop.enable) {
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };

    services = {
      logind = {
        lidSwitch = "hybrid-sleep";
        lidSwitchDocked = "ignore";
        lidSwitchExternalPower = "ignore";
        powerKey = "ignore";
        powerKeyLongPress = "ignore";
      };

      thermald = {
        enable = true;
      };

      tlp = {
        enable = true;
        settings = {
          START_CHARGE_THRESH_BAT0 = 75;
          STOP_CHARGE_THRESH_BAT0 = 80;

          START_CHARGE_THRESH_BAT1 = 75;
          STOP_CHARGE_THRESH_BAT1 = 80;
        };
      };
    };

    systemd.sleep.extraConfig = "HibernateDelaySec=1h";
  };
}
