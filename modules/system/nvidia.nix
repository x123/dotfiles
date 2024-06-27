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
}
