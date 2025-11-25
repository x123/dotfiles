{pkgs, ...}: {
  imports = [];

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
