{
  config,
  lib,
  ...
}: {
  options = {
    custom.system-nixos.services.docker = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system docker service";
      };
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.services.docker.enable) {
    virtualisation.podman.enable = true;
  };
}
