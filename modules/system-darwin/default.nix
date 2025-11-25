{lib, ...}: {
  imports = [
    ./fonts.nix
    ./karabiner.nix
    ./skhd.nix
    ./yabai.nix
  ];

  options = {
    custom.system-darwin = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable darwin";
      };
    };
  };
}
