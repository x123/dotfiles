{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.user.ai.pytorch = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable pytorch.";
      };
    };
  };

  config = lib.mkIf (config.custom.user.ai.enable && config.custom.user.ai.pytorch.enable) {
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
