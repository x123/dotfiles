{lib, ...}: {
  imports = [
    ./steam.nix
  ];

  options = {
    custom.system-nixos.games.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable system games (i.e., steam)";
    };
  };
}
