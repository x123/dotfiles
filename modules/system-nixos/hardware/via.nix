{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];
  options = {
    custom.system-nixos.hardware.via.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable via/vial udev rules for QMK";
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.hardware.via.enable) {
    services = {
      udev.packages = [pkgs.vial pkgs.via];
    };
  };
}
