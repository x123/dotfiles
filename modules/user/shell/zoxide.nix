{
  config,
  lib,
  ...
}: {
  imports = [];

  options = {
    custom.user.shell.zoxide = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable zoxide";
      };
    };
  };

  config = lib.mkIf (config.custom.user.shell.enable && config.custom.user.shell.zoxide.enable) {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      options = [
        "--cmd n"
      ];
    };
  };
}
