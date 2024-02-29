{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.ai.ollama = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable ollama.";
      };
    };
  };

  config = lib.mkIf (config.custom.ai.enable && config.custom.ai.ollama.enable) {
    home = {
      packages = builtins.attrValues {
        inherit
          (pkgs)
          #ollama
          
          oterm
          ;
      };
    };
  };
}
