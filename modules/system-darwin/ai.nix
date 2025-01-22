{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  options = {
    custom.system-darwin = {
      ai.enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable ai/llm on darwin";
      };
    };
  };
  config = lib.mkIf (cfg.system-darwin.enable && cfg.system-darwin.ai.enable) {
    environment.systemPackages = [pkgs.ollama];
  };
}
