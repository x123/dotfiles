{pkgs, ...}: let
  broken_on_darwin = [];
in {
  home = {
    packages =
      [
        pkgs.ungoogled-chromium
      ]
      ++ (
        if pkgs.stdenv.isDarwin
        then []
        else broken_on_darwin
      );
  };
}
