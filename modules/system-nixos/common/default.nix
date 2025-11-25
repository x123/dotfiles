{lib, ...}: {
  imports = [
    ./console-theme.nix
    ./filesystems.nix
    ./locale.nix
    ./zsh.nix
  ];

  options = {
    custom.system-nixos.common = {
      console-theme.enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable console-theme";
      };
      filesystems.enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable additional filesystem support";
      };
      locale.enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable common locale settings";
      };
      zsh.enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable common zsh settings";
      };
    };
  };
}
