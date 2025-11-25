{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.hardware.via.enable) {
    services = {
      udev.packages = [pkgs.vial pkgs.via];
    };
  };
}
