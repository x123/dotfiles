{lib, ...}: {
  imports = [
    ./elixir.nix
  ];

  options = {
    custom.system-nixos.dev = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system-nixos.dev modules";
      };
    };
  };
}
