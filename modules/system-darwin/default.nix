{lib, ...}: {
  imports = [
    ./aerospace.nix
    ./ai.nix
    ./fonts.nix
    ./karabiner.nix
    ./skhd.nix
    ./stats.nix
    ./yabai.nix
  ];

  options = {
    custom.system-darwin = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable darwin";
      };
      aerospace.enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable aerospace on darwin";
      };
      fonts.enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable fonts on darwin";
      };
      karabiner.enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable karabiner on darwin";
      };
      skhd.enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable skhd on darwin";
      };
      yabai.enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable yabai on darwin";
      };
    };
  };
}
