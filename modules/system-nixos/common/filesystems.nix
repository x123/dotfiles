{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.common.filesystems.enable) {
    environment.systemPackages = [
      pkgs.apfs-fuse
      pkgs.apfsprogs
    ];
  };
}
