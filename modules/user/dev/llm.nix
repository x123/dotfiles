{pkgs, ...}: {
  imports = [];

  home = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        claude-code
        ;
    };
  };
}
