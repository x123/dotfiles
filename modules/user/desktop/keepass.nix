{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.user.desktop.keepassxc = {
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
      config.custom.user.desktop.enable
      && config.custom.user.desktop.keepassxc.enable
    )
    {
      home = {
        packages = [
          pkgs.keepassxc
        ];
      };
    };
}
