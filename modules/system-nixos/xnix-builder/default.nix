{lib, ...}: {
  imports = [
    ./xnix-builder.nix
  ];

  options = {
    custom.system-nixos.xnix-builder.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable remote building on xnix";
    };
  };
}
