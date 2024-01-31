{pkgs, ...}: {
  imports = [];

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
  };
}
