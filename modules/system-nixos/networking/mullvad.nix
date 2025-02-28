{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  options = {
    custom.system-nixos.networking.mullvad = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable mullvad";
      };
    };
  };

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.networking.mullvad.enable) {
    services.mullvad-vpn.enable = true;
  };
}
