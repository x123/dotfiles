{lib, ...}: {
  imports = [
    ./wayland.nix
  ];

  options = {
    custom.system-nixos.wayland.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable system wayland";
    };
  };
}
