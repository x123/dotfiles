{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options.custom.user.desktop.slack.enable = lib.mkEnableOption "slack";

  config =
    lib.mkIf
    (
      config.custom.user.desktop.enable
      && config.custom.user.desktop.slack.enable
    )
    {
      home = {
        packages = [
          pkgs.slack
        ];
      };
    };
}
