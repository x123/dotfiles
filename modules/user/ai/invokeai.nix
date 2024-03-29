{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.ai.invokeai = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable invokeai.";
      };
    };
  };

  config = lib.mkIf (config.custom.ai.enable && config.custom.ai.invokeai.enable) {
    nix = {
      package = pkgs.nix;
      settings = {
        trusted-substituters = [
          "https://cache.nixos.org"
          "https://ai.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
        ];
      };
    };

    home = {
      packages = [
        pkgs.realesrgan-ncnn-vulkan
        inputs.nixified-ai.packages.x86_64-linux.invokeai-nvidia
      ];
    };
  };
}
