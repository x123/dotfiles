{
  config,
  lib,
  ...
}: {
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

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.networking.mullvad.enable) {
    services.mullvad-vpn.enable = true;
  };
}
