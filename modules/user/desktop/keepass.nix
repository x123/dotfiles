{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  config = lib.mkIf config.custom.desktop.enable {
    home = {
      packages = [
        pkgs.keepassxc
      ];
    };
  };
}
