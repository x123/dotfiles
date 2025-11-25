{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.desktop.ghostty = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable ghostty.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.ghostty.enable
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
