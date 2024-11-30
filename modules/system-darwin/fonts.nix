{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-darwin.enable && cfg.system-darwin.fonts.enable) {
    fonts.packages = [
      pkgs.nerd-fonts.code-new-roman
      pkgs.powerline-fonts
    ];
  };
}
