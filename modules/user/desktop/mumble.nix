{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options.custom.desktop.mumble.enable = lib.mkEnableOption "mumble";

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.mumble.enable
    )
    {
      home.packages = [
        pkgs.mumble
      ];
    };
}
