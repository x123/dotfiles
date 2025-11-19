{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options.custom.user.desktop.mumble.enable = lib.mkEnableOption "mumble";

  config =
    lib.mkIf
    (
      config.custom.user.desktop.enable
      && config.custom.user.desktop.mumble.enable
    )
    {
      home.packages = [
        pkgs.mumble
      ];
    };
}
