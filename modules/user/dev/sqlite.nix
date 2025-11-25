{pkgs, ...}: {
  imports = [];

  home = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        sqlite
        ;
    };
  };
}
