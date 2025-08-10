{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.shell.common-packages = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable common shell packages";
      };
    };
  };

  config = lib.mkIf (config.custom.user.shell.enable && config.custom.user.shell.common-packages.enable) {
    home = {
      packages = builtins.attrValues {
        inherit
          (pkgs)
          bc
          cpulimit
          dnsdbq
          file
          htop
          pciutils
          ripgrep
          visidata
          ;
      };
    };
  };
}
