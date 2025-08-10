{
  config,
  lib,
  ...
}: {
  options = {
    custom.user.dev.direnv.enable = lib.mkEnableOption "direnv integration" // {default = true;};
  };

  config = lib.mkIf (config.custom.user.dev.enable && config.custom.user.dev.direnv.enable) {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
