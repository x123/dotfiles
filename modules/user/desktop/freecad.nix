{
  config,
  lib,
  pkgs,
  ...
}: let
  freecad = pkgs.freecad.override {withWayland = config.custom.desktop.freecad.withWayland;};
  # freecad =
  #   pkgs.freecad.overrideAttrs
  #   (finalAttrs: previousAttrs: {
  #     version = "weekly-2025.06.02";
  #     src = pkgs.fetchFromGitHub {
  #       owner = "FreeCAD";
  #       repo = "FreeCAD";
  #       rev = "weekly-2025.06.02";
  #       hash = "sha256-LBKGnB3WrPHA9Ghpkt6CHWBjIiLIrMhvL8Pg6wdDe3A=";
  #       fetchSubmodules = true;
  #     };
  #     patches = [
  #       # ./0001-NIXOS-don-t-ignore-PYTHONPATH.patch
  #     ];
  #   });
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
