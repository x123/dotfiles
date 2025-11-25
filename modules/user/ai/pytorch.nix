{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.ai.pytorch = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable pytorch.";
      };
    };
  };

  config = lib.mkIf (config.custom.ai.enable && config.custom.ai.pytorch.enable) {
    home = {
      packages = builtins.attrValues {
        inherit
          (pkgs.python310Packages)
          torchWithCuda
          torchvision-bin
          ;
      };
    };
  };
}
