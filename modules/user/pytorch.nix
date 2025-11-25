{pkgs, ...}: {
  imports = [];

  home = {
    packages = builtins.attrValues {
      inherit
        (pkgs.python310Packages)
        torchWithCuda
        torchvision-bin
        ;
    };
  };
}
