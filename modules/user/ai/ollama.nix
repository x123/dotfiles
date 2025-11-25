{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.user.ai.ollama = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable ollama.";
      };
    };
  };

  config = lib.mkIf (config.custom.user.ai.enable && config.custom.user.ai.ollama.enable) {
    home = {
      # re-add oterm once fixed
      packages = builtins.attrValues {
        inherit
          (pkgs)
          ollama-cuda
          ;
      };
    };
  };
}
