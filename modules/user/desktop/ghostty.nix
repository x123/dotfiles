{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.user.desktop.ghostty = {
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
      config.custom.user.desktop.enable
      && config.custom.user.desktop.ghostty.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home = {
        file.ghostty-conf = {
          target = "${config.xdg.configHome}/ghostty/config";
          source = ./ghostty.conf;
        };
        packages = [
          pkgs.ghostty
          # inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
    };
}
