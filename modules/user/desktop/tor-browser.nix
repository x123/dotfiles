{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home = {
        packages = [
          pkgs.tor-browser
        ];
      };
    };
}
