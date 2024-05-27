{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty
    ./calibre
    ./anki.nix
    ./blender.nix
    ./chromium.nix
    ./discord.nix
    ./firefox.nix
    ./ghostty.nix
    ./obs-studio.nix
    ./keepass.nix
    ./telegram.nix
    ./tor-browser.nix
    ./video.nix
    ./yed.nix
  ];

  options.custom = {
    desktop.enable = lib.mkEnableOption "enable desktop environment";
  };

  config =
    lib.mkMerge
    [
      (lib.mkIf
        (
          config.custom.desktop.enable
          && !pkgs.stdenv.isDarwin
        )
        {
          home.packages = builtins.attrValues {
            inherit
              (pkgs)
              anydesk # broken 6.3.1 doesn't have source download - 2024-04-28
              
              dropbox
              gimp
              libreoffice
              persepolis
              xygrib
              ;
          };
        })
      (
        lib.mkIf
        (
          config.custom.desktop.enable
          && pkgs.stdenv.isDarwin
        )
        {
          home.packages = builtins.attrValues {
            inherit
              (pkgs)
              gimp
              ;
          };
        }
      )
    ];
}
