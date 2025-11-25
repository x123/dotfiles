{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.user.shell.fonts = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable shell fonts";
      };
    };
  };

  config = lib.mkIf (config.custom.user.shell.enable && config.custom.user.shell.fonts.enable) {
    fonts.fontconfig.enable = true;

    home = {
      packages = [
        pkgs.powerline-fonts
      ];
    };
  };
}
