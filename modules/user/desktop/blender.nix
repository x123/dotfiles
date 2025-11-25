{
  config,
  inputs,
  lib,
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

  config = lib.mkIf (config.custom.desktop.enable && config.custom.desktop.blender.enable) {
    home.packages = [
      inputs.blender-bin.packages.x86_64-linux.blender_4_0
    ];
  };
}
