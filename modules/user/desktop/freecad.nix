{
  config,
  lib,
  pkgs,
  ...
}: let
  freecad = pkgs.freecad.override {withWayland = config.custom.desktop.freecad.withWayland;};
in {
  imports = [];

  options = {
    custom.desktop.freecad = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable freecad.";
      };
      withWayland = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable wayland.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.freecad.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home.packages = [
        freecad
      ];
    };
}
