{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options.custom.user.desktop.mullvad.enable = lib.mkEnableOption "mullvad";

  config =
    lib.mkIf
    (
      config.custom.user.desktop.enable
      && config.custom.user.desktop.mullvad.enable
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
