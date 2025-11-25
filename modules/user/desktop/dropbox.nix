{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.user.desktop.dropbox = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the dropbox package.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.user.desktop.enable
      && config.custom.user.desktop.dropbox.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home = {
        packages = [
          # pkgs.dropbox
          pkgs.maestral
          pkgs.maestral-gui
        ];
      };
    };
}
