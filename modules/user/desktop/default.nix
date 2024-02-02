{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty
    ./calibre
    ./blender.nix
    ./chromium.nix
    ./discord.nix
    ./firefox.nix
    ./ghostty.nix
    ./keepass.nix
    ./telegram.nix
    ./tor-browser.nix
    ./video.nix
    ./yed.nix
  ];

  config = lib.mkIf config.custom.desktop.enable {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        persepolis
        dropbox
        libreoffice
        gimp
        xygrib
        ;
    };
  };
}
