{pkgs, ...}: {
  imports = [];

  # TODO add mdwatch once it hits unstable
  home = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        presenterm
        ;
      inherit
        (pkgs.unixtools)
        watch
        ;
    };
  };
}
