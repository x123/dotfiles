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

  options.custom = {
    desktop.enable = lib.mkEnableOption "enable desktop environment";
  };

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home.packages = builtins.attrValues {
        inherit
          (pkgs)
          anydesk
          dropbox
          gimp
          libreoffice
          persepolis
          xygrib
          ;
      };
    };
}
