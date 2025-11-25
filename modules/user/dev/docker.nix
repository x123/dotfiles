{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config =
    lib.mkMerge
    [
      (lib.mkIf
        (pkgs.stdenv.isLinux)
        {
          home.packages = builtins.attrValues {
            inherit
              (pkgs)
              lima
              ;
          };
        })
      (lib.mkIf
        (pkgs.stdenv.isDarwin)
        {
          home.packages = builtins.attrValues {
            inherit
              (pkgs)
              lima
              ;
          };
        })
    ];
}
