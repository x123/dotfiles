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
          pkgs.unstable-small.gnucash # TODO change back to normal
        ];
      };
    };
}
