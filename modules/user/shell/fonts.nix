{
  lib,
  pkgs,
  ...
}: {
  imports = [];

  config = (lib.mkIf (! pkgs.stdenv.isDarwin)) {
    fonts.fontconfig.enable = true;

    home = {
      packages = [
        pkgs.powerline-fonts
      ];
    };
  };
}
