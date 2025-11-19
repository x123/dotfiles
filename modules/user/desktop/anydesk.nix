{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.user.desktop.anydesk = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the anydesk package.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.user.desktop.enable
      && config.custom.user.desktop.anydesk.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home = {
        packages = [
          pkgs.anydesk
          pkgs.rustdesk
        ];
      };
    };
}
