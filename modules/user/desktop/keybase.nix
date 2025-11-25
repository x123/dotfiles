{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.user.desktop.keybase = {
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
      config.custom.user.desktop.enable
      && config.custom.user.desktop.keybase.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      services.keybase.enable = true;
      services.kbfs.enable = false;
      home = {
        packages = [
          pkgs.kbfs
          pkgs.keybase
          pkgs.keybase-gui
        ];
      };
    };
}
