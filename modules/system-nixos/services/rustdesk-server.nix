{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  options = {
    custom.system-nixos.services.rustdesk-server = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system rustdesk server service";
      };
    };
  };

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.services.rustdesk-server.enable) {
    services.rustdesk-server = {
      enable = true;
      openFirewall = false; # TCP (21115, 21116, 21117, 21118, 21119) UDP (21116)
      relayIP = "192.168.1.131";
    };
  };
}
