{lib, ...}: {
  imports = [
    ./bluetooth.nix
    ./nvidia.nix
    ./sound.nix
  ];

  options = {
    custom.system-v2.hardware = {
      bluetooth.enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable system bluetooth hardware & packages";
      };
      nvidia.enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable system nvidia hardware & packages";
      };
      sound.enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable system sound hardware & packages";
      };
    };
  };
}
