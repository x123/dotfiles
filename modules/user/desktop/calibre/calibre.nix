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
      xdg.mimeApps.associations.removed = {
        "text/plain" = ["calibre-ebook-viewer.desktop"];
      };

      home = {
        packages = builtins.attrValues {
          inherit
            (pkgs)
            calibre
            libmtp
            optipng
            ;
        };

        file = {
          mount-kobo = {
            enable = true;
            source = ./files/mount-kobo;
            target = "bin/mount-kobo";
          };

          unmount-kobo = {
            enable = true;
            source = ./files/unmount-kobo;
            target = "bin/unmount-kobo";
          };
        };
      };
    };
}
