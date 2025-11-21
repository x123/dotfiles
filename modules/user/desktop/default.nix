{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    (lib.mkAliasOptionModule ["custom" "desktop"] ["custom" "user" "desktop"])
    ./alacritty
    ./wayland
    ./x11
    ./anki.nix
    ./anydesk.nix
    ./audio.nix
    ./blender.nix
    ./calibre
    ./chromium.nix
    ./crypto.nix
    ./discord.nix
    ./dropbox.nix
    ./element.nix
    # ./firefox.nix
    ./flameshot.nix
    ./freecad.nix
    ./ghostty.nix
    ./gimp.nix
    ./gnucash.nix
    ./gtk.nix
    ./inkscape.nix
    ./irc.nix
    ./java.nix
    ./keepass.nix
    ./keybase.nix
    ./librewolf.nix
    ./mullvad.nix
    ./mumble.nix
    ./obs-studio.nix
    ./p2p.nix
    ./slack.nix
    ./subsonic.nix
    ./telegram.nix
    ./tor-browser.nix
    ./video.nix
  ];

  options.custom.user.desktop = {
    enable = lib.mkEnableOption "enable desktop environment";
    wayland.enable = lib.mkEnableOption "enable wayland environment";
    x11.enable = lib.mkEnableOption "enable x11 environment";
  };

  config =
    lib.mkMerge
    [
      (lib.mkIf
        (
          config.custom.user.desktop.enable
          && !pkgs.stdenv.isDarwin
        )
        {
          home.packages = builtins.attrValues {
            inherit
              (pkgs)
              libreoffice
              persepolis
              transmission-remote-gtk
              ;
          };
        })
    ];
}
