{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.user.desktop.crypto = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the crypto packages.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.user.desktop.enable
      && config.custom.user.desktop.crypto.enable
    )
    {
      home = {
        packages = [
          pkgs.monero-cli
          pkgs.monero-gui
          pkgs.xmrig
          pkgs.trezor-suite
        ];
      };
    };
}
