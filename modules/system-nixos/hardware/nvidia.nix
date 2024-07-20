{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.hardware.nvidia.enable) {
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
        #package = config.boot.kernelPackages.nvidiaPackages.stable; # defaults to latest
        package = config.boot.kernelPackages.nvidiaPackages.production;
        # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        #   version = "520.56.06";
        #   sha256_64bit = "sha256-UWdLAL7Wdm7EPUHKhNGNaTkGI0+FUZBptqNB92wRPEY=";
        #   settingsSha256 = "sha256-NeT3tb7NGicKHnNkuOwbte6BJsP1bUzPSE+TXnevCAM=";
        #   persistencedSha256 = lib.fakeHash;
        # };
      };
    };

    services.xserver.videoDrivers = ["nvidia"];
  };
}
