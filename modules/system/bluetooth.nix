{pkgs, ...}: {
  imports = [];

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

}
