{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
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
        inputs.blender-bin.packages.x86_64-linux.blender_4_0
      ];
    };
}
