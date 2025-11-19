{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.desktop.calibre = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the calibre package.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.user.desktop.enable
      && config.custom.user.desktop.calibre.enable
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
