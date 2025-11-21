{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.user.desktop.xmr = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the xmr packages.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.user.desktop.enable
      && config.custom.user.desktop.xmr.enable
    )
    {
      home = {
        packages = [
          pkgs.monero-cli
          pkgs.monero-gui
          pkgs.xmrig
        ];
      };
    };
}
