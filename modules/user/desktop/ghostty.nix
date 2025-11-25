{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home = {
        file.ghostty-conf = {
          target = "${config.xdg.configHome}/ghostty/config";
          source = ./ghostty.conf;
        };
        packages = [
          inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
    };
}
