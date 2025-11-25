{
  pkgs,
  config,
  ...
}: {
  imports = [];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [pkgs.vaapiVdpau];
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
}
