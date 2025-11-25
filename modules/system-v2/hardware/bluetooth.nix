{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-v2.enable && cfg.system-v2.hardware.bluetooth.enable) {
    services.blueman.enable = true;

    hardware.bluetooth = {
      enable = true;
      hsphfpd.enable = false;
      settings = {
        General = {
          ControllerMode = "bredr";
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };
}
