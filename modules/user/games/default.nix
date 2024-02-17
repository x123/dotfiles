{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
  ];

  options.custom = {
    games.enable = lib.mkEnableOption "enable games";
  };

  config =
    lib.mkIf
    (
      config.custom.games.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home.packages = builtins.attrValues {
        inherit
          (pkgs)
          freeorion
          openttd
          unciv
          ;
      };
    };
}
