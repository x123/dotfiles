{pkgs, lib, ...}: {
  imports = [];

  home.packages = with pkgs; [
    #redshift
  ];

  services.redshift = {
    enable = true;
    package = pkgs.redshift;
    latitude = 55.7;
    longitude = 12.6;
    temperature = {
      day = 6500;
      night = 3700;
    };
    settings = {
      redshift = {
        adjustment-method = "randr";
      };
    };
  };

}
