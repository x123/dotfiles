{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty
    ./wayland
    ./x11
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
    ./gnucash.nix
    ./gtk.nix
    ./inkscape.nix
    ./java.nix
    ./keepass.nix
    ./keybase.nix
    ./obs-studio.nix
    ./p2p.nix
    ./slack.nix
    ./telegram.nix
    ./tor-browser.nix
    ./video.nix
  ];

  options.custom = {
    desktop.enable = lib.mkEnableOption "enable desktop environment";
    desktop.wayland.enable = lib.mkEnableOption "enable wayland environment";
    desktop.x11.enable = lib.mkEnableOption "enable x11 environment";
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
              libreoffice
              persepolis
              xygrib
              ;
          };
        })
    ];
}
