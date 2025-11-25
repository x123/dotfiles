{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-v2.enable && cfg.system-v2.hardware.nvidia.enable) {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [pkgs.libva-vdpau-driver];
      };
      nvidia = {
        modesetting.enable = true;
        forceFullCompositionPipeline = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };

    services.xserver.videoDrivers = ["nvidia"];
  };
}
