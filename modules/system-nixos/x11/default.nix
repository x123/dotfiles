{lib, ...}: {
  imports = [
    ./x11.nix
  ];

  options = {
    custom.system-nixos.x11.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable system x11";
    };
  };
}
