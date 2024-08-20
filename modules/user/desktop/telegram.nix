{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.desktop.telegram = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the telegram package.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.telegram.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home = {
        packages = [
          pkgs.telegram-desktop
        ];
      };
    };
}
