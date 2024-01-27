{pkgs, ...}: {
  imports = [];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        sqlite
        zig
        ;
    };
  };
}
