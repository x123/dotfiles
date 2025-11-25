{
  config,
  lib,
  pkgs,
  ...
}: let
  blender = pkgs.blender.override {cudaSupport = true;};
in {
  imports = [];

  options = {
    custom.desktop.blender = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable blender.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.blender.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home.packages = [
        blender
      ];
    };
}
