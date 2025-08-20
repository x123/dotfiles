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
    user.games.enable = lib.mkEnableOption "enable games";
  };

  config =
    lib.mkMerge
    [
      (lib.mkIf
        (
          config.custom.user.games.enable
          && !pkgs.stdenv.isDarwin
        )
        {
          programs.lutris = {
            enable = true;
            # extraPackages = [ pkgs.vulkan-tools pkgs.gamescope pkgs.gamemode ];
            protonPackages = [pkgs.proton-ge-bin];
            # winePackages = [ pkgs.wineWow64Packages.full ];
          };

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
              (pkgs.unstable-small)
              bottles
              gamescope
              # lutris
              narsil
              protonup-rs
              vulkan-tools
              wine
              # wine64
              winetricks
              ;
            # inherit
            #   (pkgs.unstable-small.wineWow64Packages)
            #   unstableFull
            #   ;
          };
        })
      (lib.mkIf
        (
          config.custom.user.games.enable
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
