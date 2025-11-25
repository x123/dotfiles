{lib, ...}: {
  imports = [
    ./steam.nix
  ];

  options = {
    custom.system-v2.games.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable system games (i.e., steam)";
    };
  };
}
