{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options.custom.desktop.discord.enable = lib.mkEnableOption "discord";

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.discord.enable
    )
    {
      # nixpkgs.overlays = [
      #   (
      #     final: prev: {
      #       discord = prev.discord.overrideAttrs (
      #         _: {
      #           src = builtins.fetchTarball {
      #             url = "https://discord.com/api/download?platform=linux&format=tar.gz";
      #             sha256 = "sha256:1xjk77g9lj5b78c1w3fj42by9b483pkbfb41yzxrg4p36mnd2hkn";
      #           };
      #         }
      #       );
      #     }
      #   )
      # ];

      home = {
        packages = [
          pkgs.discord
        ];
      };
    };
}
