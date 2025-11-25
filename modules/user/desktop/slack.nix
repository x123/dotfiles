{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options.custom.desktop.slack.enable = lib.mkEnableOption "slack";

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.slack.enable
    )
    {
      home = {
        packages = [
          pkgs.slack
        ];
      };
    };
}
