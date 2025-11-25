{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  options = {
    custom.system-nixos.services.docker = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system docker service";
      };
    };
  };

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.services.docker.enable) {
    virtualisation.podman.enable = true;
  };
}
