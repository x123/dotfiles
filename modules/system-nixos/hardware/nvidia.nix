{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];
  options = {
    custom.system-nixos.hardware.nvidia.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable system nvidia hardware & packages";
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.hardware.nvidia.enable) {
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
        # package = config.boot.kernelPackages.nvidiaPackages.stable; # failing on 6.12.1
        # package = config.boot.kernelPackages.nvidiaPackages.production; # failing on 6.12.1
        package = config.boot.kernelPackages.nvidiaPackages.latest; # failing on 6.12.1
        # package = config.boot.kernelPackages.nvidiaPackages.beta; # working on 6.12.1
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
