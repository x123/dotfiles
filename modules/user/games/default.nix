{
  config,
  inputs,
  lib,
  pkgs,
  system,
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
              unciv
              angband
              blightmud
              brogue-ce
              crawl
              godot_4
              openttd
              sil
              sil-q
              tintin
              ;
            inherit
              (inputs.nixpkgs-unstable-small.legacyPackages.${system})
              narsil
              wine
              winetricks
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
