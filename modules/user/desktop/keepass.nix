{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.desktop.keepassxc = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the keepassxc package.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.keepassxc.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home = {
        packages = [
          pkgs.keepassxc
        ];
      };
    };
}
