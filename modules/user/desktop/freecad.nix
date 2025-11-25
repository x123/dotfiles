{
  config,
  lib,
  pkgs,
  ...
}: let
  freecad-weekly = pkgs.freecad.overrideAttrs (_: {
    # version = "1.1.0-weekly";
    # src = builtins.fetchTarball {
    #   url = "https://github.com/FreeCAD/FreeCAD/tarball/e9f2e8fe92f7015c6ae0d7e3c45f12532f17d744";
    #   sha256 = lib.fakeHash;
    # };

    version = "weekly-2025.06.02";
    src = pkgs.fetchFromGitHub {
      owner = "FreeCAD";
      repo = "FreeCAD";
      rev = "weekly-2025.06.02";
      hash = "sha256-LBKGnB3WrPHA9Ghpkt6CHWBjIiLIrMhvL8Pg6wdDe3A=";
      fetchSubmodules = true;
    };

    patches = [
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/nixpkgs-unstable/pkgs/by-name/fr/freecad/0001-NIXOS-don-t-ignore-PYTHONPATH.patch";
        hash = "sha256-PTSowNsb7f981DvZMUzZyREngHh3l8qqrokYO7Q5YtY=";
      })
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/nixpkgs-unstable/pkgs/by-name/fr/freecad/0002-FreeCad-OndselSolver-pkgconfig.patch";
        hash = "sha256-3nfidBHoznLgM9J33g7TxRSL2Z2F+++PsR+G476ov7c=";
      })
    ];
  });
in {
  imports = [];

  options = {
    custom.desktop.freecad = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable freecad.";
      };
      withWayland = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable wayland.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.freecad.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home.packages = [
        freecad-weekly
        pkgs.openscad-unstable
      ];
    };
}
