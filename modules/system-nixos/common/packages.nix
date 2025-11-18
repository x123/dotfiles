{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];
  options = {
    custom.system-nixos.common.packages.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable common packages";
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.common.packages.enable) {
    environment.systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        dnsutils
        iftop
        mtr
        sysstat
        tcpdump
        ;
    };
  };
}
