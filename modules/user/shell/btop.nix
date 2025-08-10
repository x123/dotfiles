{
  config,
  lib,
  ...
}: {
  imports = [];

  options = {
    custom.user.shell.btop = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable btop";
      };
    };
  };

  config = lib.mkIf (config.custom.user.shell.enable && config.custom.user.shell.btop.enable) {
    programs.btop = {
      enable = true;
      settings = {
        # https://github.com/aristocratos/btop#configurability
        color_theme = "nord";
        theme_background = false;
        update_ms = 200;
        vim_keys = true;
      };
    };
  };
}
