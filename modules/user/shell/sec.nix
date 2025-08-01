{pkgs, ...}: {
  imports = [];
  home = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        netcat-gnu
        ffuf
        urlencode
        ;
      inherit
        (pkgs.python312Packages)
        defang
        ;
    };
  };
}
