{lib, ...}: {
  imports = [
    ./x11.nix
  ];

  options = {
    custom.system-v2.x11.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable system x11";
    };
  };
}
