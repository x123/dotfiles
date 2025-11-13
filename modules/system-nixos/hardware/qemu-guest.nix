{
  config,
  lib,
  ...
}: {
  imports = [];
  options = {
    custom.system-nixos.hardware.qemu-guest.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable services.qemuGuest qemu guest agent";
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.hardware.qemu-guest.enable) {
    services.qemuGuest.enable = true;
  };
}
