{
  config,
  lib,
  pkgs,
  ...
}: {
  config =
    lib.mkIf
    (
      config.custom.user.desktop.enable
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
