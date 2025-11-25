{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.hardware.bluetooth.enable) {
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
