{
  config,
  inputs,
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
          home.packages =
            builtins.attrValues {
              inherit
                (pkgs)
                unciv
                angband
                blightmud
                brogue-ce
                godot_4
                #narsil
                
                openttd
                sil
                sil-q
                tintin
                ;
            }
            ++ [
              inputs.narsil-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];
        })
      (lib.mkIf
        (
          config.custom.games.enable
          && pkgs.stdenv.isDarwin
        )
        {
          home.packages =
            builtins.attrValues {
              inherit
                (pkgs)
                angband
                #narsil
                
                unciv
                ;
            }
            ++ [
              inputs.narsil-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];
        })
    ];
}
