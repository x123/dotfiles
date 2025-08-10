{
  config,
  lib,
  ...
}: {
  imports = [];

  options = {
    custom.system-nixos.hardware.bluetooth.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable system bluetooth hardware & packages";
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.hardware.bluetooth.enable) {
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
