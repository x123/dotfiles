{
  config,
  lib,
  pkgs,
  ...
}: {
  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home = {
        packages = [
          pkgs.deluge
        ];
      };
    };
}
