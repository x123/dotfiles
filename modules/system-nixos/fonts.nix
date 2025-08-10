{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  options = {
    custom.system-nixos.fonts.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable fonts on nixos";
    };
  };

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.fonts.enable) {
    fonts.packages = [
      pkgs.nerd-fonts.code-new-roman
      pkgs.powerline-fonts
    ];
  };
}
