{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options.custom.desktop.mullvad.enable = lib.mkEnableOption "mullvad";

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.mullvad.enable
    )
    {
      home = {
        packages = [
          pkgs.mullvad-browser
          pkgs.mullvad-vpn
        ];
      };
    };
}
