{pkgs, ...}: {
  imports = [];
  home = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        netcat-gnu
        ffuf
        ;
      inherit
        (pkgs.python312Packages)
        defang
        ;
    };
  };
}
