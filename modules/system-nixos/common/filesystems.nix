{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];
  options = {
    custom.system-nixos.common.filesystems.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable additional filesystem support";
    };
  };

  config =
    lib.mkIf (
      config.custom.system-nixos.enable
      && config.custom.system-nixos.common.enable
      && config.custom.system-nixos.common.filesystems.enable
    ) {
      environment.systemPackages = [
        pkgs.apfs-fuse
        pkgs.apfsprogs
        pkgs.nfs-utils
      ];
    };
}
