{lib, ...}: {
  imports = [
    ./tornet.nix
  ];

  options = {
    custom.system-nixos.networking = {
      tornet.enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable system tornet network bridge";
      };
    };
  };
}
