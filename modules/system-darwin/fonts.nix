{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-darwin.enable) {
    fonts.packages = [
      pkgs.nerdfonts
      pkgs.powerline-fonts
    ];
  };
}
