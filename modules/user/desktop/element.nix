{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.user.desktop.element = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the element package.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.user.desktop.enable
      && config.custom.user.desktop.element.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home = {
        packages = [
          pkgs.element-desktop
        ];
      };
    };
}
