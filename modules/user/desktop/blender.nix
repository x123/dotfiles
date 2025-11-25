{
  config,
  lib,
  pkgs,
  ...
}: let
  blender = pkgs.blender.override {cudaSupport = config.custom.user.desktop.blender.cudaSupport;};
in {
  imports = [];

  options = {
    custom.user.desktop.blender = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable blender.";
      };
      cudaSupport = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable cudaSupport.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.user.desktop.enable
      && config.custom.user.desktop.blender.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home.packages = [
        blender
      ];
    };
}
