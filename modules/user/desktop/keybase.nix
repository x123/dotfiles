{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.desktop.keybase = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the keybase package.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.keybase.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      services.keybase.enable = true;
      services.kbfs.enable = true;
      home = {
        packages = [
          pkgs.kbfs
          pkgs.keybase
          pkgs.keybase-gui
        ];
      };
    };
}
