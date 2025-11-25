{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.custom.desktop.enable {
    home = {
      packages = [
        pkgs.ungoogled-chromium
      ];
    };
  };
}
