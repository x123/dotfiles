{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options = {
    custom.system-darwin.ai.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable ai/llm on darwin";
    };
  };

  config = lib.mkIf (config.custom.system-darwin.enable && config.custom.system-darwin.ai.enable) {
    nixpkgs.overlays = [
      (
        final: prev: {
          unstable-small = import inputs.nixpkgs-unstable-small {
            system = "aarch64-darwin";
          };
        }
      )
    ];
    environment.systemPackages = [pkgs.unstable-small.ollama];
  };
}
