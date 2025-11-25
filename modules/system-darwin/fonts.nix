{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];
  options = {
    custom.system-darwin.fonts.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable fonts on darwin";
    };
  };

  config = lib.mkIf (config.custom.system-darwin.enable && config.custom.system-darwin.fonts.enable) {
    fonts.packages = [
      pkgs.nerd-fonts.code-new-roman
      pkgs.powerline-fonts
    ];
  };
}
