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
    lib.mkMerge
    [
      (lib.mkIf
        (
          config.custom.games.enable
          && !pkgs.stdenv.isDarwin
        )
        {
          home.packages = builtins.attrValues {
            inherit
              (pkgs)
              angband
              brogue-ce
              narsil
              openttd
              sil
              sil-q
              tintin
              unciv
              ;
          };
        })
      (lib.mkIf
        (
          config.custom.games.enable
          && pkgs.stdenv.isDarwin
        )
        {
          home.packages = builtins.attrValues {
            inherit
              (pkgs)
              angband
              narsil
              unciv
              ;
          };
        })
    ];
}
