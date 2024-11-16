{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty
    ./anki.nix
    ./anydesk.nix
    ./audio.nix
    ./blender.nix
    ./calibre
    ./chromium.nix
    ./discord.nix
    ./dropbox.nix
    ./element.nix
    ./firefox.nix
    ./flameshot.nix
    ./ghostty.nix
    ./gimp.nix
    ./inkscape.nix
    ./keepass.nix
    ./keybase.nix
    ./obs-studio.nix
    ./slack.nix
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
              gimp
              libreoffice
              persepolis
              xygrib
              ;
          };
        })
    ];
}
